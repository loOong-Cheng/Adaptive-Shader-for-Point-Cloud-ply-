Shader "Point Cloud/Point_geo"
{
    Properties
    {
        _Tint("Tint", Color) = (0.5, 0.5, 0.5, 1)
        _PointSize("Point Size", Range(0.001, 1)) = 0.005
        _Specular ("Specular", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(1.0, 500)) = 20
    }
 
        SubShader
    {
        Tags{ "RenderType" = "Opaque" }
        // Pass one
    Cull off
        Pass
    {   
        Tags {"LightMode"="ForwardBase"}

            CGPROGRAM
            
            
            #pragma vertex VERT
            #pragma fragment FRAG
            #pragma geometry GEO
            #pragma multi_compile _ UNITY_COLORSPACE_GAMMA
    
        #include "UnityCG.cginc"
        #include "Lighting.cginc"
    
        struct VERT_INPUT
        {
            float4 pos : POSITION;
            fixed3 color : COLOR;
            float3 normal: NORMAL;
        };
    
        struct GEO_INPUT
        {
            float4    pos    : POSITION;
            fixed3 color : COLOR;
            float3 normal: NORMAL;
        };
    
        struct FRAG_INPUT
        {
            float4    pos    : POSITION;
            fixed3 color : COLOR;
            float3 worldNormal: TEXCOORD0;
            float4 worldPos: TEXCOORD1;
        };
    
        float _PointSize;
        half4 _Tint;
        fixed4 _Specular;
        float _Gloss;
    
        GEO_INPUT VERT(VERT_INPUT v)
        {
            GEO_INPUT o = (GEO_INPUT)0;
            o.pos = v.pos;
            o.color = v.color;
            o.normal = v.normal;
            #ifdef UNITY_COLORSPACE_GAMMA
                o.color = v.color * _Tint.rgb * 2;
            #else
                o.color = v.color * LinearToGammaSpace(_Tint.rgb) * 2;
                o.color = GammaToLinearSpace(o.color);
                // o.color = v.color;
                // o.color = v.color;
                // o.color = GammaToLinearSpace(o.color);
                
            #endif
            return o;
        }
    
        [maxvertexcount(4)]
        void GEO(point GEO_INPUT p[1], inout TriangleStream<FRAG_INPUT> triStream)
        {
            // float3 cameraUp = UNITY_MATRIX_IT_MV[1].xyz;
            // float3 cameraForward = normalize(UNITY_MATRIX_IT_MV[2].xyz);
            // float3 right = cross(cameraUp, cameraForward);
            float3 BaseVec = float3(0,1,0);
            float3 cameraForward = normalize(p[0].normal);
            float3 cameraUp = normalize(cross(BaseVec,cameraForward));
            float3 right = cross(cameraUp, cameraForward);
    
            float4 v[4];

            float3 pos_world = mul(unity_ObjectToWorld, p[0].pos).xyz;
            float distToObj = distance(pos_world, _WorldSpaceCameraPos);
            
            // float size = _PointSize / min(2,(1+distToObj));
            float size;
            if (distToObj<0.82)
            {
                size = 0.008 / (1+distToObj);
            }
            else if (distToObj>3.1)
            {
                size = 0.00833;
            }
            else 
            {
                size = (0.105 + 0.096 * distToObj + 0.047 * distToObj * distToObj) / 25 / (1+distToObj);
            }

            
            v[0] = float4(p[0].pos.xyz + size * right - size * cameraUp, 1.0f);
            v[1] = float4(p[0].pos.xyz + size * right + size * cameraUp, 1.0f);
            v[2] = float4(p[0].pos.xyz - size * right - size * cameraUp, 1.0f);
            v[3] = float4(p[0].pos.xyz - size * right + size * cameraUp, 1.0f);

            // float4 v[4];
            // float size = _PointSize;
            // v[0] = float4(p[0].pos.xyz + size , 1.0f);
            // v[1] = float4(p[0].pos.xyz + size, 1.0f);
            // v[2] = float4(p[0].pos.xyz - size , 1.0f);
            // v[3] = float4(p[0].pos.xyz - size , 1.0f);
    
    
            FRAG_INPUT newVert;
    
            newVert.pos = UnityObjectToClipPos(v[0]);
            newVert.color = p[0].color;
            newVert.worldNormal = UnityObjectToWorldNormal(p[0].normal);
            newVert.worldPos = mul(unity_ObjectToWorld, v[0]);
            triStream.Append(newVert);
    
            newVert.pos = UnityObjectToClipPos(v[1]);

            newVert.worldPos = mul(unity_ObjectToWorld, v[1]);
            triStream.Append(newVert);
    
            newVert.pos = UnityObjectToClipPos(v[2]);

            newVert.worldPos = mul(unity_ObjectToWorld, v[2]);
            triStream.Append(newVert);
    
            newVert.pos = UnityObjectToClipPos(v[3]);

            newVert.worldPos = mul(unity_ObjectToWorld, v[3]);
            triStream.Append(newVert);
        }
    
        fixed4 FRAG(FRAG_INPUT input) : COLOR
        {
            // Blinn-Phone shading
            fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * 0.5;
            fixed3 worldNormal = normalize(input.worldNormal);
            fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
            fixed3 diffuse = _LightColor0.rgb * input.color * max(0, dot(worldNormal, worldLightDir));
            fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.worldPos.xyz);
            fixed3 halfDir = normalize(worldLightDir + viewDir);
            fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

            return fixed4(ambient + diffuse + specular, _Tint.a);
        }
    
            ENDCG
    }
        Pass
    {
        Tags { "LightMode"="ShadowCaster" }
        CGPROGRAM
        #pragma vertex Vertex
        #pragma geometry Geometry
        #pragma fragment Fragment
        #pragma multi_compile _ _COMPUTE_BUFFER
        #define PCX_SHADOW_CASTER 1
        #include "Disk.cginc"
        ENDCG
    }
    }

}

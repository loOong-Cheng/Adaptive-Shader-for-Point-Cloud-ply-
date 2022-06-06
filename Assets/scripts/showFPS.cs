 using UnityEngine;
 using System.Collections;
 using UnityEngine.UI;
 using TMPro;
 
 public class showFPS : MonoBehaviour {
     public TMP_Text fpsText;
     public float deltaTime;

     float time=0;
 
     void Update () {
         deltaTime += (Time.deltaTime - deltaTime) * 0.1f;
         float fps = 1.0f / deltaTime;
         if (Time.time > time){
         fpsText.text = Mathf.Ceil (fps).ToString ();
         time ++;
         }
     }
 }
 
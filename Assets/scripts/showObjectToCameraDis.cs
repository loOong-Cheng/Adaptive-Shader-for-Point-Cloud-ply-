using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class showObjectToCameraDis : MonoBehaviour
{   
    public Transform other;
    public TMP_Text distText;
    // Start is called before the first frame update
    
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (other)
        {
            float dist = Vector3.Distance(other.position, transform.position);
            distText.text = dist.ToString();
        }
    }
}

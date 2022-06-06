using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;

public class SaveDebugPointSize : MonoBehaviour
{   
    public Text pointsize;
    public Text distance;

    public string path;
    private StreamWriter writer;
    private string stringToWrite = "";
    // Start is called before the first frame update
    void Start()
    {
        path = Application.dataPath + "/test.txt";
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.frameCount<100)
        {
            stringToWrite += pointsize.text + '\t' + distance.text + '\n';
        }
    }

    private void OnApplicationQuit() {
        writer = new StreamWriter(path, true);
        writer.Write(stringToWrite);
        writer.Close();
    }
}

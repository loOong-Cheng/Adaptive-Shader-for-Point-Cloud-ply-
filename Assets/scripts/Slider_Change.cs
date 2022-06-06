using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class Slider_Change : MonoBehaviour
{
    // Start is called before the first frame update
    public TMP_Text PointSizeSliderText;
    public Slider slider;
    Material mat;

    void Start()
    {
        PointSizeSliderText.text = slider.value.ToString();
        mat = GetComponent<Renderer>().sharedMaterial;
    }

    // Update is called once per frame
    void Update()
    {
        mat.SetFloat("_PointSize",slider.value);
        PointSizeSliderText.text = slider.value.ToString();
    }
}

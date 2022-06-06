using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationObjects : MonoBehaviour
{
    int activeChildIndex = 0;
    int currentIndex = 0;
    public float Speed = 2.0f;

    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i<transform.childCount; i++)
        {
            transform.GetChild(i).gameObject.SetActive(false);
        }
        if (transform.childCount>0)
        {
            transform.GetChild(activeChildIndex).gameObject.SetActive(true);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if ((transform.childCount) > 0)
        {
            currentIndex = ((int) (Time.time *30* Speed ) ) % transform.childCount;
            if (currentIndex != activeChildIndex)
            {
                transform.GetChild(activeChildIndex).gameObject.SetActive(false);
                transform.GetChild(currentIndex).gameObject.SetActive(true);
                activeChildIndex = currentIndex;
                // Debug.Log("Current visible child is:" + activeChildIndex);
            }
        }
    }
}

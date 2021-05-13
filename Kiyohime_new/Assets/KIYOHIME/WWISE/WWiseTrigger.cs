using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class WWiseTrigger : MonoBehaviour
{
    public AK.Wwise.State stateName;
    public AK.Wwise.Switch switchName;
    public AK.Wwise.Event eventName;
    public AK.Wwise.RTPC rtpcName;
    public float valueRtpc;
    public GameObject objectSource;

    private void Awake()
    {
        GetComponent<BoxCollider2D>().isTrigger = true;
    }

    //Switch on trigger, and destroy
    private void OnTriggerEnter2D(Collider2D collision)
    {
        //je sais pas comment tu cast dans ton jeu
        if (collision.CompareTag("Player"))
        {

            if (stateName != null)
                WWISETOOL.SetState(stateName);
            if(switchName != null && objectSource != null)
                WWISETOOL.SetSwitch(switchName, objectSource);
            if (eventName != null && objectSource != null)
                WWISETOOL.PlaySound(eventName, objectSource);
            if (rtpcName != null && objectSource != null)
                WWISETOOL.SetWwiseParameter(rtpcName, valueRtpc);

            Destroy(gameObject);
        }
    }
}
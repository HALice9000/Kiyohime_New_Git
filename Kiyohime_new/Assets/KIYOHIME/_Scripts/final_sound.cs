using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class final_sound : MonoBehaviour
{
    public AK.Wwise.State musicState;

    public void ChangeMusic()
    {
        musicState.SetValue();
    }

    public AK.Wwise.Event Respiration;
    public void EventRespiration()
    {
        Respiration.Post(Squelette);


    }

   public GameObject Squelette;
}

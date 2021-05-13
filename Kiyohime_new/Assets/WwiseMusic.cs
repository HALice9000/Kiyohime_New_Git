using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WwiseMusic : MonoBehaviour
{
    public AK.Wwise.State firstMusicState;
    // Start is called before the first frame update
    void Start()
    {
        WWISETOOL.SetState(firstMusicState);
        WWISETOOL.PlaySound("Play_Music", WWISE_MANAGER.instance.musicSource);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

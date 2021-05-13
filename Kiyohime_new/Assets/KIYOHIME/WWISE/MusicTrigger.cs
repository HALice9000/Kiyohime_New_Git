using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(BoxCollider2D))]
public class MusicTrigger : MonoBehaviour
{
    public AK.Wwise.State musicState;

    private void Awake()
    {
        GetComponent<BoxCollider2D>().isTrigger = true;
    }

    //Switch on trigger, and destroy
    private void OnTriggerEnter2D(Collider2D collision)
    {
        //je sais pas comment tu cast dans ton jeu
        if(collision.CompareTag("Player"))
        {
            WWISETOOL.SwitchMusic(musicState); //Switch
            Destroy(gameObject);
        }
    }
}

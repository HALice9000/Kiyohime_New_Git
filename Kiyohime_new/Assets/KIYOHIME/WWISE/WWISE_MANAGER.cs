using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//This script need to be post on empty gameobject on the scene

public class WWISE_MANAGER : MonoBehaviour
{

    //Mark as singleton
    public static WWISE_MANAGER instance;

    private void Awake()
    {
        if(instance != null)
        {
            DestroyImmediate(gameObject);
            return;
        }

        instance = this;

        //Instantiate Source
        musicSource = new GameObject("Music Source");
        ambientSource = new GameObject("Ambient Source");
        mainMenuSource = new GameObject("MainMenu Source");
        pauseMenuSource = new GameObject("PauseMenu Source");
        dialogueSource = new GameObject("Dialogue Source");

        //Set source parent
        musicSource.transform.SetParent(transform);
        ambientSource.transform.SetParent(transform);
        mainMenuSource.transform.SetParent(transform);
        pauseMenuSource.transform.SetParent(transform);
        dialogueSource.transform.SetParent(transform);



        //Make no destroy
        DontDestroyOnLoad(gameObject);
    }

    //On utilise des objet pour les source des différents sons qui n'ont pas de spatialisation (du coup on s'en fou de leur position dans la scene)
    public GameObject musicSource { get; private set; }
    public GameObject ambientSource { get; private set; }
    public GameObject mainMenuSource { get; private set; }
    public GameObject pauseMenuSource { get; private set; }
    public GameObject dialogueSource { get; private set; }
}

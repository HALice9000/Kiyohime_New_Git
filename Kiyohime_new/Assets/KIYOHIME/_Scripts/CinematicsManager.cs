﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine.Timeline;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.SceneManagement;

public class CinematicsManager : MonoBehaviour
{
    #region Singleton

    public static CinematicsManager instance;

    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else
        {
            Destroy(this);
        }
    }

    #endregion

    PlayableDirector playableDirector;
    TimelineAsset timelineAsset;
    bool aIsPressed = false;

    // Start is called before the first frame update
    void Start()
    {
        playableDirector = GetComponent<PlayableDirector>();
        timelineAsset = (TimelineAsset)playableDirector.playableAsset;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("A") && aIsPressed == false && SceneManager.GetActiveScene().buildIndex != 1)
        {
            aIsPressed = true;

            ResumeCinematic();
        }
    }

    public void ResumeCinematic()
    {
        playableDirector.Resume();
    }

    public void PauseCinematic()
    {
        playableDirector.Pause();
    }
}

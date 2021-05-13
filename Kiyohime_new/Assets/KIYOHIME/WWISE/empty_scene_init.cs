using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class empty_scene_init : MonoBehaviour
{
    void Start()
    {
        SceneManager.LoadScene(1);
    }
}

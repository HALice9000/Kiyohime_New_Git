using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CinematicTrigger : MonoBehaviour
{
    [SerializeField] private s_dialogueSystem ds;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            CinematicsManager.instance.ResumeCinematic();
            Destroy(gameObject);
        }
    }
}

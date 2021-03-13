using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_TriggerBox : MonoBehaviour
{
    public s_dialogue dialogue;
    [SerializeField] private s_dialogueSystem ds;
    bool isTrigger = false;
    public bool noCinematic = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (isTrigger == true)
        {
            if (Input.GetKeyDown(KeyCode.F))
            {
                ds.DisplayNextSentence();
            }
        }
    }

    public void LaunchThisDialogue()
    {
        ds.StartDialogue(dialogue);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            CinematicsManager.instance.ResumeCinematic();

            if (noCinematic == true)
                LaunchThisDialogue();

            isTrigger = true;
            collision.gameObject.GetComponent<Gamekit2D.PlayerCharacter>().inCinematic = true;
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            isTrigger = false;
            Destroy(gameObject);
        }
    }
}

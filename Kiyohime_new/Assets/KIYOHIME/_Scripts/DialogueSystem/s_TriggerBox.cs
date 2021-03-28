using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_TriggerBox : MonoBehaviour
{
    [SerializeField] private s_dialogueSystem ds;
    public s_dialogue dialogue;
    public bool haveDialogue = true;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void LaunchThisDialogue()
    {
        ds.StartDialogue(dialogue);
        CinematicsManager.instance.ResumeCinematic();
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            CinematicsManager.instance.ResumeCinematic();

            if (haveDialogue == true)
                LaunchThisDialogue();

            collision.gameObject.GetComponent<Gamekit2D.PlayerCharacter>().inCinematic = true;
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            Destroy(gameObject);
        }
    }
}

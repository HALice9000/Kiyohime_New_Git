using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class s_dialogueTrigger : MonoBehaviour
{
    public s_dialogue dialogue;
    [SerializeField] private s_dialogueSystem ds;

    public void TriggerDialogue()
    {
        ds.StartDialogue(dialogue);
    }
}

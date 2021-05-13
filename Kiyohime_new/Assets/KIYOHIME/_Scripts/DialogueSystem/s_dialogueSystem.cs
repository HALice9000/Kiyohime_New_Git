using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

[System.Serializable]
public class CharacterIdentity
{
    public GameObject[] charactersPics;
    public string[] characterName;
    public string[] characterTitle;
}

public class s_dialogueSystem : MonoBehaviour
{
    public CharacterIdentity characterID;

    public Queue<string> sentences;

    [SerializeField] private TMP_Text _speakerName;
    [SerializeField] private TMP_Text _speakerTitle;
    [SerializeField] private TMP_Text _speakerText;
    [SerializeField] private float delayBeforeDial = 2.5f;

    GameObject player;
    GameObject dialogueBox;

    int picNum = 0;

    int[] charaIndex;

    bool playerIsFree = true;
    bool dialogueStarted = false;

    void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        sentences = new Queue<string>();
        dialogueBox = transform.GetChild(0).GetChild(0).gameObject;
    }

    private void Update()
    {
        if (dialogueBox.activeInHierarchy && dialogueStarted)
        {
            CanUseInputs();
        }
    }

    private void CanUseInputs()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            DisplayNextSentence();
        }
        if (Input.GetButtonDown("B"))
        {
            DisplayNextSentence();
        }
    }

    public void SetPlayerStatic(bool isStatic)
    {
        player.GetComponent<Gamekit2D.PlayerCharacter>().inCinematic = isStatic;
    }

    private void EnqueueCharacterInfos(s_dialogue dialogue)
    {
        foreach (var sentence in dialogue.sentences)
        {
            sentences.Enqueue(sentence);
        }
    }

    private void DequeueCharacterInfos()
    {
        string sentence = sentences.Dequeue();
        _speakerText.text = sentence;

        WWISETOOL.PlayNextDialogue();
    }

    public void StartDialogue(s_dialogue dialogue)
    {
        StartCoroutine(EnumDelayDial(delayBeforeDial, dialogue));
    }

    private void ResumeDialogue(s_dialogue dialogue)
    {
        SetPlayerStatic(true);
        dialogueBox.SetActive(true);
        picNum = 0;

        sentences.Clear();

        charaIndex = new int[dialogue.names.Length];

        for (int i = 0; i < charaIndex.Length; i++)
        {
            switch (dialogue.names[i])
            {
                case "Anchin":
                    charaIndex[i] = 0;
                    break;
                case "Kiyohime":
                    charaIndex[i] = 1;
                    break;
                case "Suiko":
                    charaIndex[i] = 2;
                    break;
                case "Yamata-no-Orochi":
                    charaIndex[i] = 3;
                    break;
                default:
                    break;
            }
        }

        EnqueueCharacterInfos(dialogue);
        SetIfPlayerIsFreeAtEnd(dialogue);

        DisplayNextSentence();
        dialogueStarted = true;
    }

    private void SetIfPlayerIsFreeAtEnd(s_dialogue dialogue)
    {
        playerIsFree = dialogue.playerFreeAtEnd;
    }

    private void SetSpeackerInfos()
    {
        foreach (GameObject picObj in characterID.charactersPics)
        {
            picObj.SetActive(false);
        }

        if (picNum < charaIndex.Length)
        {
            characterID.charactersPics[charaIndex[picNum]].SetActive(true);
            _speakerName.text = characterID.characterName[charaIndex[picNum]];
            _speakerTitle.text = characterID.characterTitle[charaIndex[picNum]];

            picNum++;
        }
    }

    public void DisplayNextSentence()
    {
        SetSpeackerInfos();

        if (sentences.Count == 0)
        {
            EndDialogue();
            return;
        }

        DequeueCharacterInfos();
    }

    private void EndDialogue()
    {
        transform.GetChild(0).GetChild(0).gameObject.SetActive(false);

        CinematicsManager.instance.ResumeCinematic();

        if (playerIsFree)
            SetPlayerStatic(false);
    }

    private IEnumerator EnumDelayDial(float delay, s_dialogue dialogue)
    {
        yield return new WaitForSeconds(delay);

        ResumeDialogue(dialogue);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonDoAction : MonoBehaviour
{
    [SerializeField] private GameObject objectToSwitchActiveState;
    [SerializeField] private string buttonName;

    bool switchTF = false;
    bool canInteract = false;

    public void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            canInteract = true;
        }
    }

    public void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            canInteract = false;
        }
    }

    public void Update()
    {
        if (canInteract)
            if (Input.GetButtonDown(buttonName))
            {
                switchTF = !switchTF;
                objectToSwitchActiveState.SetActive(switchTF);
            }
    }
}

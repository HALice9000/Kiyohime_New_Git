using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplayQuote : MonoBehaviour
{
    [SerializeField] private s_dialogueSystem ds;
    [SerializeField] private GameObject quote;
    [SerializeField] private float quoteTimeOnScreen = 3.0f;

    [SerializeField] private int index = 20;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            StartCoroutine(QuoteDisplayEnum());
            WWISETOOL.PlaySpecificDialogue(index);
        }
    }

    private IEnumerator QuoteDisplayEnum()
    {
        ShowQuote();

        yield return new WaitForSeconds(quoteTimeOnScreen);

        HideQuote();

        Destroy(gameObject);
    }

    public void ShowQuote()
    {
        quote.SetActive(true);
    }

    public void HideQuote()
    {
        quote.SetActive(false);
    }
}

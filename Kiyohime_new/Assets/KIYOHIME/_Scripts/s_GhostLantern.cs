using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_GhostLantern : MonoBehaviour
{
    public bool detected = false;
    public float maxLife = 1.1f;
    public float timeBeforeBoom = 3.0f;
    public float ratio = 10.0f;
    Renderer r;
    Material sh;
    float lanternLife = 0;
    bool freshStarted = false;

    // Start is called before the first frame update
    void Start()
    {
        r = transform.GetChild(0).gameObject.GetComponent<Renderer>();
        sh = r.material;
    }

    // Update is called once per frame
    void Update()
    {
        if (detected == true)
        {
            if (freshStarted == false)
            {
                freshStarted = true;
                StartCoroutine(BurnEffect());
            }
            sh.SetFloat("_Burn", lanternLife);
        }

        if (lanternLife >= 1.1f)
        {
            StopAllCoroutines();
            Destroy(gameObject, 0.01f);
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            detected = true;
        }
    }

    IEnumerator BurnEffect()
    {
        yield return new WaitForSeconds(timeBeforeBoom / ratio);//timeBeforeBoom / ratio
        lanternLife += maxLife / ratio;//maxLife / ratio
        StartCoroutine(BurnEffect());
    }
}

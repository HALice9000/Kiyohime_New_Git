using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonLaunchAnim : MonoBehaviour
{
    public AnimationState s;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag == "Player")
        {
            s.state = 1;
            GetComponent<BoxCollider2D>().enabled = false;
            collision.gameObject.GetComponent<Rigidbody2D>().constraints = RigidbodyConstraints2D.FreezeAll;
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WallJump : MonoBehaviour
{
    public bool _gripped = false;
    public string _gripTag = "";
    Rigidbody2D rb2D;

    // Start is called before the first frame update
    void Start()
    {
        rb2D = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {
        if (_gripped == true)
        {
            rb2D.constraints = RigidbodyConstraints2D.FreezeAll;
        }
        else
        {
            rb2D.constraints = RigidbodyConstraints2D.None;
            rb2D.constraints = RigidbodyConstraints2D.FreezeRotation;
        }
        if (Input.GetButtonDown("Jump"))
        {
            _gripped = false;
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag == _gripTag)
        {
            _gripped = true;
        }
    }
}

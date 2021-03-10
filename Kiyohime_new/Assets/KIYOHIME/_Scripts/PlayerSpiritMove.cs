using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSpiritMove : MonoBehaviour
{
    public GameObject _player;
    public GameObject _Spirit;
    bool spirited = false;

    // Start is called before the first frame update
    void Start()
    {
        _Spirit.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (spirited == true)
        {
            _player.transform.position = _Spirit.transform.position;
        }
    }

    public void MakeSpirit()
    {
        _Spirit.SetActive(true);
        _player.GetComponent<Rigidbody2D>().constraints = RigidbodyConstraints2D.None;
        _player.GetComponent<Rigidbody2D>().constraints = RigidbodyConstraints2D.FreezeRotation;

        _player.GetComponent<SpriteRenderer>().enabled = false;
        _player.GetComponent<CapsuleCollider2D>().enabled = false;
        spirited = true;
    }

    public void MakeLiving()
    {
        _Spirit.SetActive(false);
        _player.GetComponent<SpriteRenderer>().enabled = true;
        _player.GetComponent<CapsuleCollider2D>().enabled = true;

        _player.GetComponent<Rigidbody2D>().constraints = RigidbodyConstraints2D.None;
        _player.GetComponent<Rigidbody2D>().constraints = RigidbodyConstraints2D.FreezeRotation;
        spirited = false;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathWall : MonoBehaviour
{
    public Transform _wall;
    public Transform _checkpoints;
    public float _speed = 10f;
    float speed;

    int indexed = 0;

    Transform[] checkp;
    Transform actualCheck;

    public bool _moving = false;

    void Start()
    {
        checkp = new Transform[_checkpoints.childCount];
        speed = _speed;

        for (int i = 0; i < checkp.Length; i++)
        {
            checkp[i] = _checkpoints.GetChild(i);
        }

        actualCheck = checkp[indexed];
    }

    void FixedUpdate()
    {
        if (_moving == true)
        {
            WallSystem();
            MonstersSystem();
        }

        //_wall.position = Vector3.Lerp(_wall.position, checkp[indexed].position, _speed);

        //_wall.Translate(dir * _speed, Space.World);

        /*
        Vector3 dir = _checkpoints[indexed].position - transform.position;
        float angle = Mathf.Atan2(dir.y, dir.x) * Mathf.Rad2Deg;
        transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);
        */
    }

    void MonstersSystem()
    {
        actualCheck = checkp[indexed];
        float dist = Vector3.Distance(_wall.position, actualCheck.position);

        if (dist < 0.1f)
        {
            if (indexed < checkp.Length - 1)
                indexed++;
        }
        _wall.LookAt(checkp[indexed]);
        _wall.Translate(-_wall.right * speed);

        if (indexed == checkp.Length - 1)
        {
            StopWall();
        }
    }

    void WallSystem()
    {
        actualCheck = checkp[indexed];
        float dist = Vector3.Distance(_wall.position, actualCheck.position);

        if (dist < 0.1f)
        {
            if (indexed < checkp.Length - 1)
                indexed++;
        }
        _wall.LookAt(checkp[indexed]);
        _wall.Translate(-_wall.right * speed);

        if (indexed == checkp.Length - 1)
        {
            StopWall();
        }
    }

    public void MoveWall()
    {
        speed = _speed;
    }

    public void StopWall()
    {
        speed = 0;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            _moving = true;
        }
    }
}

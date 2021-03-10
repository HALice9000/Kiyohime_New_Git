using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_monsterFollow : MonoBehaviour
{
    [SerializeField] private Transform _pointToFollow;
    [SerializeField] private float _followSpeed;
    float speed = 0f;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SpeedChanger());
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = Vector3.Lerp(transform.position, _pointToFollow.position, speed * Time.deltaTime);
    }

    IEnumerator SpeedChanger()
    {
        yield return new WaitForSeconds(1.5f);
        speed = Random.Range(_followSpeed, _followSpeed * 3.0f);

        StartCoroutine(SpeedChanger());
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class s_FloatFromTo : MonoBehaviour {

    float progress = 0;

    public float GetProgression()
    {
        return progress;
    }

    public void FloatFromTo(float _from, float _to, float delay, float steps)
    {
        progress = _from;
        StartCoroutine(FromToDelay(_from, _to, delay, steps));
    }

    IEnumerator FromToDelay(float f, float t, float d, float s)
    {
        yield return new WaitForSeconds(s * d);

        progress += s;

        if (progress <= t)
        {
            StartCoroutine(FromToDelay(progress, t, d, s));
        }
    }
}

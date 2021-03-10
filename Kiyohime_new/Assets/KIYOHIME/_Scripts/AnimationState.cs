using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationState : MonoBehaviour
{
    public int state = 0;
    public Animator anim;

    public void IncreaseState()
    {
        state++;
    }

    private void Update()
    {
        anim.SetInteger("AState", state);
    }
}

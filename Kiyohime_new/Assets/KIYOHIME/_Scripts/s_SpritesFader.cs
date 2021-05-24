using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]
public class s_SpritesFader : MonoBehaviour
{
    [Range(0, 1)]
    public float _alpha = 1f;
    public float _delay = 1f;
    public float _steps = 0.1f;

    public SpriteRenderer[] sprites;

    SpriteRenderer[] spriteRenderer;

    public s_FloatFromTo FFT;

    void FindSprites()
    {
        spriteRenderer = new SpriteRenderer[sprites.Length];

        for (int i = 0; i < sprites.Length; i++)
        {
            spriteRenderer[i] = sprites[i].GetComponent<SpriteRenderer>();
        }
    }

    private void OnEnable()
    {
        FindSprites();
        FFT.FloatFromTo(0, 1, _delay, _steps);
    }

    void Update()
    {
        _alpha = FFT.GetProgression();
        foreach (var sprite in spriteRenderer)
        {
            sprite.color = new Color(1, 1, 1, _alpha);
        }
    }
}
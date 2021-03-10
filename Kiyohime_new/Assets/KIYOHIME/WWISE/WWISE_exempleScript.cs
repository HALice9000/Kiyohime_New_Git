using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WWISE_exempleScript : MonoBehaviour
{
    //Imaginons que ce soit le script de Kiyohime, ou son script sonore. (Elle a donc ce script attacher sur son GameObject
    //ON fera ici l'exemple du footStep, Jump, et d'un loop de respiration.


        //ATTTETIOOOOON ! j'ai mis ce script aussi sur Ellen pour que tu voit le son du saut (c'est un anim event sur l'animation jump 1 qui déclenche la fonction OnJump ( tu peu virer tout ca )


        //on fait une class pour les sons ( plus pratique ^^ )
    [System.Serializable]
    public class KiyohimeSound
    {
        public AK.Wwise.Event footSteps, jump, respirationOn, respirationOff; //On décliare tout les events dont on a besoin. (on verra ensemble lequels).

        public AK.Wwise.Switch footGrass, footWater, footRock; //On déclare les différents états que les sons de ses pied peuvent avoir.

        public AK.Wwise.Switch currentGroundSurface; //Ici on entreposera la valeur actuel du son de ses pieds.

        public AK.Wwise.RTPC currLifeInfo;
    }

    //on oublie pas de la déclarer.
    public KiyohimeSound sound;


    public int KiyohimeCurrLife;
    float t = 0;

    void Start()
    {
        //La surface par défaut.
        sound.currentGroundSurface = sound.footGrass;
        WWISETOOL.SetSwitch(sound.currentGroundSurface, gameObject); //Et on active l'état.
    }






    //peut etre appeler par un trigger ?
    public void ChangeFootstepSurface(string surfaceName)
    {
        //Celon l'info et met l'etat.
        if(surfaceName == "Grass")
        {
            sound.currentGroundSurface = sound.footGrass;
        }
        else if(surfaceName == "Rock")
        {
            sound.currentGroundSurface = sound.footRock;
        }
        else if(surfaceName == "Water")
        {
            sound.currentGroundSurface = sound.footWater;
        }
        else
        {
            Debug.Log("Incorect surface Type for Kiyohime footSteps");
        }

        WWISETOOL.SetSwitch(sound.currentGroundSurface, gameObject); //Et on active l'état.
    }

    //peut être appeler par l'anim (avec des anim event) par exemple.
    public void FootStepHit()
    {
        WWISETOOL.PlaySound(sound.footSteps, gameObject); //on joue le son, qui dépandra de l'état des footStep.
    }







    //Pour les event simple
    public void OnJump()
    {
        WWISETOOL.PlaySound(sound.jump, gameObject);
    }





    //pour les boucles.
    //on commence la boucle quand on veux.
    public void RespirationOn()
    {
        WWISETOOL.PlaySound(sound.respirationOn, gameObject);
    }

    //et on la termine quand on veux.
    public void RespirationOff()
    {
        WWISETOOL.PlaySound(sound.respirationOff, gameObject);
    }



    //pour les paramêtres
    private void Update()
    {
        //un exemple ou la vie déscend et remonte , le son pourrait être filtrer plus la vie est basse

        t += Time.deltaTime;

        KiyohimeCurrLife = Mathf.RoundToInt(Mathf.Abs(100 * Mathf.Sin(0.2f * t)));

        WWISETOOL.SetWwiseParameter(sound.currLifeInfo, KiyohimeCurrLife);
    }


}

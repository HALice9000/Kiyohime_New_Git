using System.Collections.Generic;
using UnityEngine;

public static class WWISETOOL 
{
    #region Bank Manager

    /// <summary>
    /// Doit être appelé au plus proche du début du lancement de l'application. (L'objet WWISE du mainmenu fait deja ca, mais on peut le faire à partir du code si tu préferes). Ne doit être appeler qu'une fois.
    /// </summary>
    /// <param name="bankName"></param>
    public static void LoadBank(AK.Wwise.Bank bankName)
    {
        bankName.Load();
    }

    /// <summary>
    /// Aucune utilité pour votre projet, mais sait on jamais.
    /// </summary>
    /// <param name="bankName"></param>
    public static void UnLoadBank(AK.Wwise.Bank bankName)
    {
        bankName.Unload();
    }

    #endregion

    #region Play A Sound

    /// <summary>
    /// Appeler cette fonction pour jouer un son, "source" est l'emmeteur du son. Ne doit pas être appeler en continu.
    /// </summary>
    /// <param name="eventName"></param>
    /// <param name="source"></param>
    public static void PlaySound(AK.Wwise.Event eventName, GameObject source)
    {
        eventName.Post(source);

        if(!allSourceEmitter.Contains(source))
        {
            allSourceEmitter.Add(source);
        }
    }
    /// <summary>
    /// Surchage de la méthode permettant d'appeler un event par son nom (string). Ne doit pas être appeler en continu.
    /// </summary>
    /// <param name="eventName"></param>
    /// <param name="source"></param>
    public static void PlaySound(string eventName, GameObject source)
    {
        AkSoundEngine.PostEvent(eventName, source);

        if (!allSourceEmitter.Contains(source))
        {
            allSourceEmitter.Add(source);
        }
    }

    #endregion

    #region SetParameter

    /// <summary>
    /// Appeler pour changer un paramêtre (currLife, velocityY, ... ) peut être appeler en continu.
    /// </summary>
    /// <param name="parameter"></param>
    /// <param name="value"></param>
    public static void SetWwiseParameter(AK.Wwise.RTPC parameter, float value)
    {
        parameter.SetGlobalValue(value);
    }
    public static void SetWwiseParameter(AK.Wwise.RTPC parameter, int value)
    {
        parameter.SetGlobalValue(value);
    }

    #endregion

    #region Set A State

    /// <summary>
    /// Un objet (ou une instance d'objet) peut être dans différents état (FootStep Grass, FootStep Rock, ...) sans que le reste des objets soient impacté. Ne doit pas être appeler en continu.
    /// </summary>
    /// <param name="switchName"></param>
    /// <param name="target"></param>
    public static void SetSwitch(AK.Wwise.Switch switchName, GameObject target)
    {
        switchName.SetValue(target);
    }

    /// <summary>
    /// Le jeu  peut être dans différents état (LevelNumber, day or night, inPause, ...) tout les objet peuvent être impacté (mais pas forcement). Ne doit pas être appeler en continu.
    /// </summary>
    /// <param name="statehName"></param>
    public static void SetState(AK.Wwise.State statehName)
    {
        statehName.SetValue();
    }

    #endregion

    #region Clear Audio
    public static List<GameObject> allSourceEmitter = new List<GameObject>();

    /// <summary>
    /// Appeler cet fonction pour stoper tout les sons entrain d'être jouer. (Attention ce sera fait sans Fade). Ne doit pas être appeler en continu.
    /// </summary>
    public static void ClearAllSound()
    {
        foreach(GameObject sources in allSourceEmitter)
        {
            AkSoundEngine.StopAll(sources);
        }

        allSourceEmitter.Clear();
    }

    #endregion

    #region Dialogue System

    private static int currDialogue = 0;

    /// <summary>
    /// A chaque fois que le texte change, appeler cette fonction. Il faut que l'emitter du son soit le même à chaque appel (Ca peut être n'importe quel objet). Ne doit pas être appeler en continu.
    /// </summary>
    /// <param name="emitter"></param>
    public static void PlayNextDialogue(GameObject emitter)
    {
        string eventToPlay = "D_" + currDialogue.ToString(); //Les events de dialogue seront appelé ainsi "D_0, D_1, D_2, ..." avec une simple int toString on peut faire un automatisation.
        PlaySound(eventToPlay, emitter);
        currDialogue++;
    }
    /// <summary>
    /// Uniquement pour appeler un dialogue spécifique (Pas utile mais on sait jamais). Ne doit pas être appeler en continu.
    /// </summary>
    /// <param name="emitter"></param>
    /// <param name="specificDialogue"></param>
    public static void PlayNextDialogue(GameObject emitter, int specificDialogue)
    {
        string eventToPlay = "D_" + specificDialogue.ToString();
        PlaySound(eventToPlay, emitter);
        currDialogue++;
    }

    #endregion
}

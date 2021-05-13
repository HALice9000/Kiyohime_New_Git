using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class s_ButtonMenu : MonoBehaviour
{
    public void ButtonLaunchGame(int index)
    {
        
        SceneManager.LoadScene(index);
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}

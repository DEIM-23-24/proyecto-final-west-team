using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine;

public class MenuPausa : MonoBehaviour
{
    public GameObject canvasPausa;
    private bool estaEnPausa = false;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            if (estaEnPausa)
                ReanudarJuego();
            else
                PausarJuego();
        }
        if (estaEnPausa && (Input.GetKeyDown(KeyCode.Escape))){
        SceneManager.LoadScene("Menu");
        }
    }

    void PausarJuego()
    {
        canvasPausa.SetActive(true);

        Time.timeScale = 0f;

        estaEnPausa = true;
    }

    void ReanudarJuego()
    {
        canvasPausa.SetActive(false);

        Time.timeScale = 1f;

        estaEnPausa = false;
    }
}

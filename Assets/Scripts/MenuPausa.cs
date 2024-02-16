using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine;

public class MenuPausa : MonoBehaviour
{
    public GameObject canvasPausa;
    public bool estaEnPausa = false;
    public bool activado = false;

    void Update()
    {
        if (Input.GetAxisRaw("Pausa")>0 && !activado)
        {
            activado = true;
            if (estaEnPausa)
                ReanudarJuego();
            else
                PausarJuego();
        }
        if(Input.GetAxisRaw("Pausa")==0){
            activado = false;
        }
        if (Input.GetAxisRaw("VolverMenu")>0 && estaEnPausa)
        {
           SceneManager.LoadScene("Menu");
        Time.timeScale = 1f;
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

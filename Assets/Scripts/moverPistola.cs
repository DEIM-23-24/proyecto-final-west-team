using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class moverPistola : MonoBehaviour
{
public float posStart;
public float posExit;
public bool arriba;
    // Start is called before the first frame update
    void Start()
    {
        arriba = true;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetAxis("Vertical") < 0)
        arriba = false;
        if (Input.GetAxis("Vertical") > 0)
        arriba  = true;
        if(arriba){
            gameObject.GetComponent<RectTransform>().anchoredPosition = new Vector3(-806, posStart, 0);
        }else{
            gameObject.GetComponent<RectTransform>().anchoredPosition = new Vector3(-806, posExit, 0);
            }
        if (arriba && (Input.GetKeyDown(KeyCode.Return)))
        SceneManager.LoadScene("Lvl1");
    }
}

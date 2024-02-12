using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Audio : MonoBehaviour
{
    public AudioSource audioSource;
    public AudioClip clip;
    public float volume;
    
    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Sonido")
        {
            audioSource.PlayOneShot(clip, volume);
        }


    }

}

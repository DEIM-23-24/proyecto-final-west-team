using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class movimiento : MonoBehaviour
{

    private Rigidbody rigidBody;
    private Animator animator;
    public float velocidad;
    public float velocidadSalto;
    public bool suelo;

    public int cantidadSaltos;

    private int contadorSalto;

    void Start(){
        rigidBody = gameObject.GetComponent<Rigidbody>();
        animator = gameObject.GetComponent<Animator>();
        suelo = true;
        contadorSalto = 0;
    }
    void Update()
    {
        float velocidadActualX = velocidad * Input.GetAxis("Horizontal");
        float velocidadActualZ = velocidad * Input.GetAxis("Vertical");
        rigidBody.velocity = new Vector3(velocidadActualX, rigidBody.velocity.y, velocidadActualZ);
        Vector3 vel = rigidBody.velocity;
        float velocidadActual = vel.magnitude;
        animator.SetFloat("Velocidad",velocidadActual);
        
        Vector3 direccion = new Vector3(Input.GetAxis("Horizontal"),0,Input.GetAxis("Vertical"));
        if(direccion.magnitude > 0){
            float angulo = Mathf.Atan2(direccion.x,direccion.z) * Mathf.Rad2Deg;
            transform.rotation =Quaternion.Euler(0, angulo, 0);
        }
        if (Input.GetKeyDown("space") && (suelo == true || contadorSalto < cantidadSaltos))
        {
            Saltar();
        }
    }
    public void Saltar(){
        if(contadorSalto == 0){
            animator.SetTrigger("Saltar");
            animator.ResetTrigger("Suelo");
        }
        suelo = false;
        contadorSalto++;
        rigidBody.AddForce(new Vector3(0,velocidadSalto,0),ForceMode.Impulse);
    }

    
    void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.tag == "suelo"){
            suelo = true;
            contadorSalto = 0;
            animator.SetTrigger("Suelo");
        }
    }
}

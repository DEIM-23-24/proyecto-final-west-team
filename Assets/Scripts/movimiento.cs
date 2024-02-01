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
    public float velocidadRotacion;

    public int cantidadSaltos;
    public float cullDownSalto;
    private float contCullDownSalto = 0;

    private int contadorSalto;

    void Start(){
        rigidBody = gameObject.GetComponent<Rigidbody>();
        animator = gameObject.GetComponent<Animator>();
        suelo = true;
        contadorSalto = 0;
    }
    void Update()
    {
        Vector3 delante = Camera.main.GetComponent<Transform>().forward;
        Vector3 derecha = Camera.main.GetComponent<Transform>().right;
        delante.y = 0;
        derecha.y = 0;
        Vector3 total = delante * Input.GetAxis("Vertical") + derecha * Input.GetAxis("Horizontal");
        Vector3 gravedad = new Vector3(0,rigidBody.velocity.y,0);
        rigidBody.velocity = total * velocidad + gravedad;
        Vector3 vel = rigidBody.velocity;
        float velocidadActual = vel.magnitude;
        animator.SetFloat("Velocidad",velocidadActual);
        animator.SetFloat("Velocidad Vertical",vel.y);
        
        if(total.magnitude > 0){
           
           Quaternion mirarA = Quaternion.LookRotation(total.normalized, Vector3.up);
            transform.rotation = Quaternion.RotateTowards(transform.rotation,mirarA, velocidadRotacion);
        }
        if (Input.GetKeyDown("space") && (suelo == true || contadorSalto < cantidadSaltos) && contCullDownSalto > cullDownSalto)
        {
            Saltar();
        }
        contCullDownSalto += Time.deltaTime;
    }
    public void Saltar(){
        animator.SetTrigger("Saltar");
        animator.ResetTrigger("Suelo");
        suelo = false;
        contadorSalto++;
        rigidBody.AddForce(new Vector3(0,velocidadSalto,0),ForceMode.Impulse);
    }

    
    void OnCollisionEnter(Collision collision)
    {
        Debug.Log("Chocar");
        Debug.Log(collision.gameObject.name);
        Debug.Log(collision.gameObject.tag);
        if(collision.gameObject.tag == "suelo"){
            suelo = true;
            contadorSalto = 0;
            contCullDownSalto = 0;
            animator.SetTrigger("Suelo");
        }
    }
}

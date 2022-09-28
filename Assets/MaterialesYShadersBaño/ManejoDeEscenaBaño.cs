using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ManejoDeEscenaBaño : MonoBehaviour
{
    public List<GameObject> objetos;
    
    public GameObject camaraOrbital;
    public GameObject camaraPrimeraPersona;

    public GameObject centro;
    public GameObject objetoQueEstoyMirando;

    public int luzSeleccionada;
    private int objetoActual;
    private float timeDelay;
    void Start(){
        luzSeleccionada = 0;
        //camaraOrbital.transform.position = new Vector3(7,5,0);
        //camaraOrbital.transform.Rotate(new Vector3(30,-90,0))
        
        objetoActual = -1;
        objetoQueEstoyMirando=centro;
        camaraPrimeraPersona.GetComponent<Camera>().enabled = false;
        camaraPrimeraPersona.transform.position=new Vector3(5,5,-4);
        camaraOrbital.GetComponent<Camera>().enabled = true;

        camaraOrbital.transform.Translate(new Vector3(5,5,5));
        camaraOrbital.transform.LookAt(centro.transform.position);
        
        //camaraOrbital.transform.Rotate(new Vector3(0,-30,0));
        timeDelay=0;
    
    }   


    void Update()
    {    
        if (Input.GetKeyDown(KeyCode.Z))
        {
            luzSeleccionada++;
            if(luzSeleccionada == 3){
                luzSeleccionada = 0;
            }
        }
        if(Input.GetKeyDown(KeyCode.V))
            cambiarCamara();


        


        if(Input.GetKey(KeyCode.C) && timeDelay<=Time.time){
            objetoActual++;
            if(objetos.Count==objetoActual){
                objetoActual = -1;
                camaraOrbital.transform.Translate(new Vector3(centro.transform.position.x+1,centro.transform.position.y,centro.transform.position.z+1));
                camaraOrbital.transform.LookAt(centro.transform.position);
                objetoQueEstoyMirando=centro;
                
            }
            else{
                //camaraOrbital.Reset();
                objetoQueEstoyMirando=objetos[objetoActual];
                camaraOrbital.transform.Translate(new Vector3(objetos[objetoActual].transform.position.x+1,objetos[objetoActual].transform.position.y,objetos[objetoActual].transform.position.z+1));
                camaraOrbital.transform.LookAt(objetos[objetoActual].transform.position);
                //camaraOrbital.transform.position = new Vector3(objetos[0].transform.position.x,objetos[0].transform.position.y,objetos[0].transform.position.z);
            }
            
            timeDelay=Time.time+0.8f;
        }

        if(Input.GetKey(KeyCode.X) && timeDelay<=Time.time){
            objetoActual--;
            if(objetoActual<=-1){
                objetoActual = -1;
                camaraOrbital.transform.position=new Vector3(centro.transform.position.x+1,centro.transform.position.y,centro.transform.position.z+1);
                camaraOrbital.transform.LookAt(centro.transform.position);
                objetoQueEstoyMirando=centro;
                
            }
            else{
                //camaraOrbital.Reset();
                objetoQueEstoyMirando=objetos[objetoActual];
                camaraOrbital.transform.position=new Vector3(objetos[objetoActual].transform.position.x+1,objetos[objetoActual].transform.position.y,objetos[objetoActual].transform.position.z+1);
                camaraOrbital.transform.LookAt(objetos[objetoActual].transform.position);
                //camaraOrbital.transform.position = new Vector3(objetos[0].transform.position.x,objetos[0].transform.position.y,objetos[0].transform.position.z);
            }
            
            timeDelay=Time.time+0.8f;
        }

        if(Input.GetKey(KeyCode.R) ){
            camaraOrbital.transform.position=new Vector3(objetos[objetoActual].transform.position.x+1,objetos[objetoActual].transform.position.y,objetos[objetoActual].transform.position.z+1);
        }


        foreach (GameObject objeto in objetos){
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Spot_Position_w", new Vector3 (29,7,14.6f)); 
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Spot_Direction_w", new Vector3 (30,1,12));   
            /*objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Spot_Position_w", new Vector3 (29,7,18.5f)); 
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Spot_Direction_w", new Vector3 (30,1,13.5f)); */            
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Directional_Position_w", new Vector3 (0,-5,0));        
            objeto.GetComponent<Renderer>().sharedMaterial.SetFloat("_rangeOfLight", 0.01f);
            objeto.GetComponent<Renderer>().sharedMaterial.SetFloat("_Apertura", 0.997f);       
            
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_LightIntensity_d", new Vector3 (0.6078f,0.6078f,0.6078f)); 
            
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Puntual_Position_w", new Vector3 (-4,10,0));
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Puntual_Position_w2", new Vector3 (11,10,0));
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Puntual_Position_w3", new Vector3 (27,10,0));
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Puntual_Position_w4", new Vector3 (-24,10,0));
            objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_AmbientLight", new Vector3 (1,1,1)); 

            if(luzSeleccionada == 2){//Direccional
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (1,1,1)); 
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor2", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor3", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor4", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetFloat("_rangeOfLight", 0.01f); 
            }

            if(luzSeleccionada == 1){ //Spot
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (1,1,1)); 
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (0,0,0)); 
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor2", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor3", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor4", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_AmbientLight", new Vector3 (0,0,0)); 
                objeto.GetComponent<Renderer>().sharedMaterial.SetFloat("_rangeOfLight", 0.0004f); 
                if(objeto.name == "AcrilicoLinterna" || objeto.name == "Linterna"){
                    objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (1,1,1));
                    objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_Puntual_Position_w", new Vector3 (-23.5f,5,-10));
                }
            } 

            if(luzSeleccionada == 0){ //Puntual
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (1,1,1));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor2", new Vector3 (1,1,1));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor3", new Vector3 (1,1,1));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor4", new Vector3 (1,1,1));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (0,0,0));
                objeto.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (0,0,0)); 
                objeto.GetComponent<Renderer>().sharedMaterial.SetFloat("_rangeOfLight", 0.01f); 
                
            }

        }
        

        


        
        
        
    }

    void FixedUpdate()
    { 
        if(camaraPrimeraPersona.GetComponent<Camera>().enabled){
            if(Input.GetKey(KeyCode.LeftShift))
                moverAbajo();
            if(Input.GetKey(KeyCode.Space))
                moverArriba();
            if(Input.GetKey(KeyCode.W))
                desplazarseAdelante();
            if(Input.GetKey(KeyCode.S))
                desplazarseAtras();
            if(Input.GetKey(KeyCode.A))
                rotarIzquierda();
            if(Input.GetKey(KeyCode.D))
                rotarDerecha();
        }
        else{

        
            if(Input.GetKey(KeyCode.A)){
                OrbitalRotarIzquierda();
            }
            if(Input.GetKey(KeyCode.D)){
                OrbitalRotarDerecha();
            }
            if(Input.GetKey(KeyCode.W)){
                SubirCamaraOrbital();
            }
            if(Input.GetKey(KeyCode.S)){
                BajarCamaraOrbital();
            }/*
            if(Input.GetKey("up")){
                
            }
            if(Input.GetKey("down")){
                
            }*/
            if(Input.GetAxis("Mouse ScrollWheel")<0  || Input.GetKey("up"))
                Alejarse();
            if(Input.GetAxis("Mouse ScrollWheel")>0  || Input.GetKey("down"))
                Acercarse();
        }
    }

    private void Wait(){
     StartCoroutine(_wait());
    }
    IEnumerator _wait(){
        print(Time.time);
        yield return new WaitForSecondsRealtime(20000);
        print(Time.time);
    }

    void SubirCamaraOrbital(){
        camaraOrbital.transform.Translate(new Vector3(0,.15f,0));
        camaraOrbital.transform.LookAt(objetoQueEstoyMirando.transform.position);
    }
    void BajarCamaraOrbital(){
        camaraOrbital.transform.Translate(new Vector3(0,-.15f,0));
        camaraOrbital.transform.LookAt(objetoQueEstoyMirando.transform.position);
    }
    void AumentarZoom(){
        //camaraOrbital.transform.main.orthographicSize++;
        //camaraOrbital.GetComponent<Camera>().fieldOfView = Mathf.Lerp(camaraOrbital.GetComponent<Camera>().fieldOfView, 20, Time.deltaTime * 5);
        camaraOrbital.GetComponent<Camera>().fieldOfView -=3; 
    }
    void DisminuirZoom(){
        camaraOrbital.GetComponent<Camera>().fieldOfView +=3;
        
    }

    void OrbitalRotarIzquierda(){
        if(objetoActual == -1){
            camaraOrbital.transform.RotateAround (centro.transform.position,Vector3.up,20 * Time.deltaTime * 5);
        }
        else{
            camaraOrbital.transform.RotateAround (objetos[objetoActual].transform.position,Vector3.up,20 * Time.deltaTime * 5);
        }
    }

    private void Acercarse(){
       camaraOrbital.transform.Translate(new Vector3(0,0,1.5f));
    }
    private void Alejarse(){
        camaraOrbital.transform.Translate(new Vector3(0,0,-1.5f));
    }
    
    void OrbitalRotarDerecha(){
        
        if(objetoActual == -1){
            camaraOrbital.transform.RotateAround (centro.transform.position,Vector3.up,20 * Time.deltaTime * -5);
        }
        else{
            camaraOrbital.transform.RotateAround (objetos[objetoActual].transform.position,Vector3.up,20 * Time.deltaTime * -5);
        }
    }


    private void cambiarCamara(){
        camaraOrbital.GetComponent<Camera>().enabled = !camaraOrbital.GetComponent<Camera>().enabled;
        camaraPrimeraPersona.GetComponent<Camera>().enabled = !camaraPrimeraPersona.GetComponent<Camera>().enabled;

    }


    private void moverArriba(){
        camaraPrimeraPersona.transform.Translate(new Vector3(0,0.1f,0));
    }
    private void moverAbajo(){
        camaraPrimeraPersona.transform.Translate(new Vector3(0,-0.1f,0));
    }
    private void desplazarseAdelante(){
       camaraPrimeraPersona.transform.Translate(new Vector3(0,0,0.1f));
    }
    private void desplazarseAtras(){
        camaraPrimeraPersona.transform.Translate(new Vector3(0,0,-0.1f));
    }
    private void rotarIzquierda(){
        camaraPrimeraPersona.transform.Rotate(new Vector3(0,-2,0));
    }
    private void rotarDerecha(){
        camaraPrimeraPersona.transform.Rotate(new Vector3(0,2,0));
    }
}

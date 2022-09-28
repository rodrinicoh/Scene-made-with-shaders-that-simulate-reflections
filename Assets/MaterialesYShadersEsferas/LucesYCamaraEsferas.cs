using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class LucesYCamaraEsferas : MonoBehaviour
{
    public List<GameObject> esferas;
    
    public GameObject camaraOrbital;

    public GameObject plano;

    public int luzSeleccionada;
    private int esferaActual;
    private float timeDelay;
    
    public GameObject objetoQueEstoyMirando;
    void Start(){
        luzSeleccionada = 0;
        //camaraOrbital.transform.position = new Vector3(7,5,0);
        //camaraOrbital.transform.Rotate(new Vector3(30,-90,0));
        
        esferaActual = -1;
        objetoQueEstoyMirando=plano;
        camaraOrbital.transform.Translate(new Vector3(5,5,5));
        camaraOrbital.transform.LookAt(plano.transform.position);
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
/*
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
        }
        if(Input.GetAxis("Mouse ScrollWheel")<0)
            DisminuirZoom();
        if(Input.GetAxis("Mouse ScrollWheel")>0)
            AumentarZoom();*/

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


        if(Input.GetKey(KeyCode.C) && timeDelay<=Time.time){
            esferaActual++;
            if(esferas.Count==esferaActual){
                objetoQueEstoyMirando=plano;
                esferaActual = -1;
                camaraOrbital.transform.LookAt(plano.transform.position);
                
            }
            else{
                //camaraOrbital.Reset();
                objetoQueEstoyMirando=esferas[esferaActual];
                camaraOrbital.transform.LookAt(esferas[esferaActual].transform.position);
                //camaraOrbital.transform.position = new Vector3(esferas[0].transform.position.x,esferas[0].transform.position.y,esferas[0].transform.position.z);
            }
            
            timeDelay=Time.time+0.8f;
        }


        foreach (GameObject esfera in esferas){
            esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_Spot_Position_w", new Vector3 (esfera.transform.position.x,5,esfera.transform.position.z)); 
            esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_Spot_Direction_w", new Vector3 (esfera.transform.position.x,1,esfera.transform.position.z));               
            esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_Directional_Position_w", new Vector3 (0,-5,0));        
            esfera.GetComponent<Renderer>().sharedMaterial.SetFloat("_rangeOfLight", 0.05f);       
            
            esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_LightIntensity_d", new Vector3 (0.6078f,0.6078f,0.6078f)); 
            
            esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_Puntual_Position_w", new Vector3 (esfera.transform.position.x,5,esfera.transform.position.z));

            if(luzSeleccionada == 2){//Direccional
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (1,1,1)); 
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (0,0,0));
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (0,0,0));
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (0,0,0));
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (1,1,1));
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (0,0,0));
            }

            if(luzSeleccionada == 1){ //Spot
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (1,1,1)); 
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (0,0,0)); 
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (0,0,0));
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (0,0,0));
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (0,0,0));
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (1,1,1));
            } 

            if(luzSeleccionada == 0){ //Puntual
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (1,1,1));
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (0,0,0));
                esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (0,0,0)); 
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_PuntualColor", new Vector3 (1,1,1));
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_DirectionalColor", new Vector3 (0,0,0));
                plano.GetComponent<Renderer>().sharedMaterial.SetVector("_SpotColor", new Vector3 (0,0,0)); 
                if(esfera.name == "Plastico negro"){
                    esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_Puntual_Position_w", new Vector3 (esfera.transform.position.x,2.19f,esfera.transform.position.z));
                }
                if(esfera.name == "Sangre"){
                    esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_Puntual_Position_w", new Vector3 (esfera.transform.position.x,2.19f,esfera.transform.position.z));
                }
                
            }
            esfera.GetComponent<Renderer>().sharedMaterial.SetVector("_AmbientLight", new Vector3 (1,1,1)); 
            esfera.GetComponent<Renderer>().sharedMaterial.SetFloat("_Apertura", 0.016f);    
            
            plano.GetComponent<Renderer>().sharedMaterial.SetFloat("_Apertura", 0.897f);    

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
/*
    void SubirCamaraOrbital(){
        //camaraOrbital.transform.Translate(new Vector3(0,.15f,-.15f));
    }
    void BajarCamaraOrbital(){
        //camaraOrbital.transform.Translate(new Vector3(0,-.15f,.15f));
    }*/
     void SubirCamaraOrbital(){
        camaraOrbital.transform.Translate(new Vector3(0,.15f,0));
        camaraOrbital.transform.LookAt(objetoQueEstoyMirando.transform.position);
    }
    void BajarCamaraOrbital(){
        camaraOrbital.transform.Translate(new Vector3(0,-.15f,0));
        camaraOrbital.transform.LookAt(objetoQueEstoyMirando.transform.position);
    }
    private void Acercarse(){
       camaraOrbital.transform.Translate(new Vector3(0,0,1.5f));
    }
    private void Alejarse(){
        camaraOrbital.transform.Translate(new Vector3(0,0,-1.5f));
    }/*
    void AumentarZoom(){
        //camaraOrbital.transform.main.orthographicSize++;
        //camaraOrbital.GetComponent<Camera>().fieldOfView = Mathf.Lerp(camaraOrbital.GetComponent<Camera>().fieldOfView, 20, Time.deltaTime * 5);
        camaraOrbital.GetComponent<Camera>().fieldOfView -=3; 
    }
    void DisminuirZoom(){
        camaraOrbital.GetComponent<Camera>().fieldOfView +=3;
        
    }*/

    void OrbitalRotarIzquierda(){
        if(esferaActual == -1){
            camaraOrbital.transform.RotateAround (plano.transform.position,Vector3.up,20 * Time.deltaTime * 5);
        }
        else{
            camaraOrbital.transform.RotateAround (esferas[esferaActual].transform.position,Vector3.up,20 * Time.deltaTime * 5);
        }
    }
    
    void OrbitalRotarDerecha(){
        
        if(esferaActual == -1){
            camaraOrbital.transform.RotateAround (plano.transform.position,Vector3.up,20 * Time.deltaTime * -5);
        }
        else{
            camaraOrbital.transform.RotateAround (esferas[esferaActual].transform.position,Vector3.up,20 * Time.deltaTime * -5);
        }
    }
}

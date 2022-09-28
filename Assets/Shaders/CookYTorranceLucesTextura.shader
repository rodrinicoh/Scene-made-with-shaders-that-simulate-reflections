Shader "Unlit/CookYTorranceLucesTextura"
{
    Properties
    {

        _MaterialColor ("Material Color", Color) = (1, 1, 1, 1)
       [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {} //en _MainTex se guarda la textura
       [NoScaleOffset] _MainTex2 ("Texture2", 2D) = "white" {} 
       [NoScaleOffset] _MainTex3 ("Texture3", 2D) = "white" {} 

        //Puntual
        _Puntual_Position_w ("Ubicacion Luz Puntual", Vector) = (0, 5, 0, 1)
        _PuntualColor ("Color Luz Puntual", Color) = (1, 1, 1, 1)

        //Direccional
        _Directional_Position_w ("Posición Luz Direccional", Vector) = (0, 5, 0, 1)
        _DirectionalColor ("Color Luz Direccional", Color) = (0, 0, 0, 1)

        //Spot
        _SpotColor ("Color Luz Spot", Color) = (0, 0, 0, 1)
        _Spot_Position_w ("Ubicacion Luz Spot", Vector) = (0, 5, 0, 1)
        _Spot_Direction_w ("Direccion Luz Spot", Vector) = (0, 5, 0, 1)
        _Apertura ("Apertura", Range(0.0, 1)) = 0.5 
        _rangeOfLight ("factor de intensidad", Range(0.0, 1)) = 0.05

        //difuso
        _MaterialKd("MaterialKd", Vector) = (0.34615,0.3143,0.0903,1)
        _LightIntensity_d("LightIntensity_d", Color) = (1,1,1,1) //Ip
        _MaterialKs("MaterialKs", Vector) = (0.79735,0.72399,0.208006,1)

        _AmbientLight("AmbientLight",Color) = (1,1,1,1)
        _MaterialKa("MaterialKa",Vector) = (0,0,0,0)

        
        roughness ("Roughness (alfa)", Range (0.0,1.0)) = 0.5
        fresnel ("fresnel (F0)", Range (0.0,1.0)) = 0.5


        //Puntual
        _Puntual_Position_w2 ("Ubicacion Luz Puntual 2", Vector) = (0, 5, 0, 1)
        _PuntualColor2 ("Color Luz Puntual 2", Color) = (0, 0, 0, 0)

        //Puntual
        _Puntual_Position_w3 ("Ubicacion Luz Puntual 3", Vector) = (0, 5, 0, 1)
        _PuntualColor3 ("Color Luz Puntual 3", Color) = (0, 0, 0, 0)

        //Puntual
        _Puntual_Position_w4 ("Ubicacion Luz Puntual 4", Vector) = (0, 5, 0, 1)
        _PuntualColor4 ("Color Luz Puntual 4", Color) = (0, 0, 0, 0)


        
        
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass{
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            sampler2D _MainTex2;
            sampler2D _MainTex3;

            struct vertexData
            {
                float4 position : POSITION; //coordenadas objeto
                float3 normal : NORMAL;//coordenadas objeto
                float2 uv : TEXCOORD0; //coordenada de ,  float2 es un vector de 4 componentes y el tipo de cada componente es TEXTCORD0
            };

            struct v2f
            {
                float4 position : SV_POSITION; //coordenadas clipping
                float4 positionworld : TEXCOORD1;
                float3 normal : TEXCOORD0; //world space
                float2 uv : TEXCOORD2; //coordenada de textura
            };

            float4 _Puntual_Position_w;
            float4 _PuntualColor;
            float4 _MaterialColor;
            float roughness;
            float3 _LightIntensity_d;
            float fresnel;
            
            float4 _MaterialKd;
            static const float PI = 3.14159265358979323846;
            float4 _Directional_Position_w; 
            float4 _Spot_Position_w;
            float4 _SpotColor;
            float4 _Spot_Direction_w;
            float  _Apertura, _rangeOfLight;
            float4 _DirectionalColor;
            float4 _AmbientLightColor;
            float4 _MaterialKs;

            float4 _AmbientLight;

            float4 _MaterialKa;

            float4 _Puntual_Position_w2;
            float4 _PuntualColor2;

            float4 _Puntual_Position_w3;
            float4 _PuntualColor3;

            float4 _Puntual_Position_w4;
            float4 _PuntualColor4;

            v2f vertexShader(vertexData v)
            {
                float4 position_w = mul(unity_ObjectToWorld, v.position);
                float3 normal_w = normalize(UnityObjectToWorldNormal(v.normal));
                v2f output;
                output.position = UnityObjectToClipPos(v.position);
                output.positionworld = position_w;
                output.normal = normal_w;
                output.uv = v.uv;

                return output;
            }
            
            fixed4 fragmentShader (v2f i) : SV_Target{

                float3 luzPuntual = 0;
                float3 luzPuntual2 = 0;
                float3 luzPuntual3 = 0;
                float3 luzPuntual4 = 0;
                float3 luzDireccional = 0;
                float3 luzSpot = 0;
                float distanc = 0;

                float3 N = normalize(i.normal);
                float3 L = normalize(_Puntual_Position_w.xyz - i.positionworld.xyz);
                float NdotL = max(dot(N,L),0.0);

                float3 V= normalize(_WorldSpaceCameraPos - i.positionworld); //coordenada del mundo
                float3 H = normalize((L+V));

                    
                float NdotV = max(dot(N,V),0.0);

                float NdotH = max(dot(N,H),0.0);
                float LdotH = max(dot(L,H),0.0);
                float HdotV = max(dot(H,V),0.0);
                

                float m = clamp(1-HdotV, 0, 1);
                float Fpow=pow(m,5); //pow 5
                float F=fresnel+(1-fresnel)*Fpow;

                //G
                float G = min(1, (2*NdotH*NdotV)/HdotV); //diap 129
                G= min (G,(2*NdotH*NdotL)/HdotV);

                //D
                float arriba = 1/(PI*pow(roughness,2)*pow(NdotH,4));
                //float D = pow( (1/(PI*pow(roughness,2)*pow(NdotH,4))) , (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));//diap 123
                float D = arriba* exp( (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));

                float cookTorranceSinDifuso = (F*D*G)/(4*NdotL*NdotV);

                float3 cookTorrance =cookTorranceSinDifuso*_LightIntensity_d;

                if(NdotL>0.0){
                    distanc = distance(_Puntual_Position_w.xyz, i.positionworld.xyz);
                    float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc));
                    //float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc));
                    float3 luzPuntualDifusa = factorAtenuacionPuntual*_LightIntensity_d*NdotL*_MaterialKd*_PuntualColor;
                    float3 specularPuntual = factorAtenuacionPuntual*_PuntualColor*_MaterialKs.rgb*cookTorranceSinDifuso*_LightIntensity_d;

                    luzPuntual = luzPuntualDifusa+specularPuntual;
                }

                
                //direccional
                L = normalize(-_Directional_Position_w.xyz );
                NdotL = max(dot(N,L),0.0);

                if(NdotL>0.0){
                    H = normalize((L+V));
                    NdotL = max(dot(N,L),0.0);
                    NdotH = max(dot(N,H),0.0);
                    LdotH = max(dot(L,H),0.0);
                    HdotV = max(dot(H,V),0.0);

                    float m = clamp(1-HdotV, 0, 1);
                    float Fpow=pow(m,5); //pow 5
                    float F=fresnel+(1-fresnel)*Fpow;

                    //G
                    float G = min(1, (2*NdotH*NdotV)/HdotV); //diap 129
                    G= min (G,(2*NdotH*NdotL)/HdotV);

                    //D
                    float arriba = 1/(PI*pow(roughness,2)*pow(NdotH,4));
                    //float D = pow( (1/(PI*pow(roughness,2)*pow(NdotH,4))) , (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));//diap 123
                    float D = arriba* exp( (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));

                    float cookTorranceSinDifuso = (F*D*G)/(4*NdotL*NdotV);

                    

                    distanc = distance(_Directional_Position_w.xyz, i.positionworld.xyz);
                    float3 factorAtenuacionDireccional= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc)+ (_rangeOfLight*distanc*distanc));
                    float3 specularLuzDireccional = _DirectionalColor*_MaterialKs.rgb*cookTorranceSinDifuso; //o deberia ser con G?

                    float3 luzDireccionalDifusa = NdotL*_DirectionalColor*_MaterialKd.rgb*_LightIntensity_d*factorAtenuacionDireccional; //difusa Direccional


                    luzDireccional = luzDireccionalDifusa+specularLuzDireccional;
                }
                

                //spot
                L = normalize(_Spot_Position_w.xyz - i.positionworld.xyz); 
                NdotL = max(dot(N,L),0.0);
                if(NdotL>0.0){

                    H = normalize((L+V));
                    NdotL = max(dot(N,L),0.0);
                    NdotH = max(dot(N,H),0.0);
                    LdotH = max(dot(L,H),0.0);
                    HdotV = max(dot(H,V),0.0);

                    float m = clamp(1-HdotV, 0, 1);
                    float Fpow=pow(m,5); //pow 5
                    float F=fresnel+(1-fresnel)*Fpow;

                    //G
                    float G = min(1, (2*NdotH*NdotV)/HdotV); //diap 129
                    G= min (G,(2*NdotH*NdotL)/HdotV);

                    //D
                    float arriba = 1/(PI*pow(roughness,2)*pow(NdotH,4));
                    //float D = pow( (1/(PI*pow(roughness,2)*pow(NdotH,4))) , (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));//diap 123
                    float D = arriba* exp( (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));

                    float cookTorranceSinDifuso = (F*D*G)/(4*NdotL*NdotV);

                    float3 LspotDir = normalize(_Spot_Direction_w); 
                    distanc = distance(_Spot_Position_w.xyz, i.positionworld.xyz);
                    float3 factorAtenuacionSpot= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc));
                    //float3 factorAtenuacionSpot= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc));             
                    float3 luzSpotDifusa = 0;
                    float3 specularLuzSpot = 0;
                    float cosenoDelAnguloEntreElObjetoYLaLuz = dot(L,LspotDir);
                    if (cosenoDelAnguloEntreElObjetoYLaLuz> _Apertura){
                        float intensidad = max(dot(N,L),0);
                        if(intensidad > 0){
                            luzSpotDifusa= factorAtenuacionSpot*intensidad * _SpotColor *_MaterialKd.rgb*_LightIntensity_d; //difusa spot 
                            specularLuzSpot = factorAtenuacionSpot*_SpotColor*_MaterialKs.rgb*cookTorranceSinDifuso*_LightIntensity_d;
                        }                        
                    }

                    luzSpot = luzSpotDifusa+specularLuzSpot;
                }

                float3 ambient =  _AmbientLight * _MaterialKa;

                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col2 = tex2D(_MainTex2, i.uv);
                fixed4 col3 = tex2D(_MainTex3, i.uv);

                //Puntuales Extra
                L = normalize(_Puntual_Position_w2.xyz - i.positionworld.xyz);
                NdotL = max(dot(N,L),0.0);
                if(NdotL>0.0){
                    H = normalize((L+V));
                    NdotH = max(dot(N,H),0.0);
                    LdotH = max(dot(L,H),0.0);
                    HdotV = max(dot(H,V),0.0);

                    float m = clamp(1-HdotV, 0, 1);
                    float Fpow=pow(m,5); //pow 5
                    float F=fresnel+(1-fresnel)*Fpow;

                    //G
                    float G = min(1, (2*NdotH*NdotV)/HdotV); //diap 129
                    G= min (G,(2*NdotH*NdotL)/HdotV);

                    //D
                    float arriba = 1/(PI*pow(roughness,2)*pow(NdotH,4));
                    //float D = pow( (1/(PI*pow(roughness,2)*pow(NdotH,4))) , (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));//diap 123
                    float D = arriba* exp( (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));

                    float cookTorranceSinDifuso = (F*D*G)/(4*NdotL*NdotV);

                    distanc = distance(_Puntual_Position_w2.xyz, i.positionworld.xyz);
                    float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc));
                    //float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc));
                    float3 luzPuntualDifusa = factorAtenuacionPuntual*_LightIntensity_d*NdotL*_MaterialKd*_PuntualColor2;
                    float3 specularPuntual = factorAtenuacionPuntual*_PuntualColor2*_MaterialKs.rgb*cookTorranceSinDifuso*_LightIntensity_d;

                    luzPuntual2 = luzPuntualDifusa+specularPuntual;
                }
                L = normalize(_Puntual_Position_w3.xyz - i.positionworld.xyz);
                NdotL = max(dot(N,L),0.0);

                if(NdotL>0.0){
                    H = normalize((L+V));
                    NdotH = max(dot(N,H),0.0);
                    LdotH = max(dot(L,H),0.0);
                    HdotV = max(dot(H,V),0.0);

                    float m = clamp(1-HdotV, 0, 1);
                    float Fpow=pow(m,5); //pow 5
                    float F=fresnel+(1-fresnel)*Fpow;

                    //G
                    float G = min(1, (2*NdotH*NdotV)/HdotV); //diap 129
                    G= min (G,(2*NdotH*NdotL)/HdotV);

                    //D
                    float arriba = 1/(PI*pow(roughness,2)*pow(NdotH,4));
                    //float D = pow( (1/(PI*pow(roughness,2)*pow(NdotH,4))) , (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));//diap 123
                    float D = arriba* exp( (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));

                    float cookTorranceSinDifuso = (F*D*G)/(4*NdotL*NdotV);

                    distanc = distance(_Puntual_Position_w3.xyz, i.positionworld.xyz);
                    float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc));
                    //float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc));
                    float3 luzPuntualDifusa = factorAtenuacionPuntual*_LightIntensity_d*NdotL*_MaterialKd*_PuntualColor3;
                    float3 specularPuntual = factorAtenuacionPuntual*_PuntualColor3*_MaterialKs.rgb*cookTorranceSinDifuso*_LightIntensity_d;

                    luzPuntual3 = luzPuntualDifusa+specularPuntual;
                }

                L = normalize(_Puntual_Position_w4.xyz - i.positionworld.xyz);
                NdotL = max(dot(N,L),0.0);

                if(NdotL>0.0){
                    H = normalize((L+V));
                    NdotH = max(dot(N,H),0.0);
                    LdotH = max(dot(L,H),0.0);
                    HdotV = max(dot(H,V),0.0);

                    float m = clamp(1-HdotV, 0, 1);
                    float Fpow=pow(m,5); //pow 5
                    float F=fresnel+(1-fresnel)*Fpow;

                    //G
                    float G = min(1, (2*NdotH*NdotV)/HdotV); //diap 129
                    G= min (G,(2*NdotH*NdotL)/HdotV);

                    //D
                    float arriba = 1/(PI*pow(roughness,2)*pow(NdotH,4));
                    //float D = pow( (1/(PI*pow(roughness,2)*pow(NdotH,4))) , (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));//diap 123
                    float D = arriba* exp( (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));

                    float cookTorranceSinDifuso = (F*D*G)/(4*NdotL*NdotV);

                    distanc = distance(_Puntual_Position_w4.xyz, i.positionworld.xyz);
                    float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc));
                    //float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc));
                    float3 luzPuntualDifusa = factorAtenuacionPuntual*_LightIntensity_d*NdotL*_MaterialKd*_PuntualColor4;
                    float3 specularPuntual = factorAtenuacionPuntual*_PuntualColor4*_MaterialKs.rgb*cookTorranceSinDifuso*_LightIntensity_d;

                    luzPuntual4 = luzPuntualDifusa+specularPuntual;
                }




                fixed4 fragColor= fixed4(luzPuntual+luzPuntual2+luzPuntual3+luzPuntual4+luzDireccional+luzSpot+ambient,1);
                fragColor=fragColor*_MaterialColor*col*col2*col3;
                //fragColor+=col;
                return fragColor;
            }
            ENDCG
        }
    }
}
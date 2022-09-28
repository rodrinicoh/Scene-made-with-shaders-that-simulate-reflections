Shader "Unlit/PhongLuces"
{
    Properties
    {
        
        _MaterialColor ("Material Color", Color) = (0.25, 0.5, 0.5, 1)
        _LightIntensity_d("LightIntensity_d", Color) = (1,1,1,1) //Ip
        _LightIntensity_s("LightIntensity_s", Color) = (1,1,1,1) //Is
        _LightIntensity_a("LightIntensity_a", Color) = (1,1,1,1) //Ia

        //puntual
        _Puntual_Position_w("Light Position (World)", Vector) = (0,5,0,1)
        _PuntualColor ("Color Luz Puntual", Color) = (1, 1, 1, 1)

        //Direccional
        _Directional_Position_w ("Direccion Luz Direccional", Vector) = (0, 5, 0, 1)
        _DirectionalColor ("Color Luz Direccional", Color) = (1, 1, 1, 1)

        //Spot
        _SpotColor ("Color Luz Spot", Color) = (1, 1, 1, 1)
        _Spot_Position_w ("Ubicacion Luz Spot", Vector) = (0, 5, 0, 1)
        _Spot_Direction_w ("Direccion Luz Spot", Vector) = (0, 5, 0, 1)
        _Apertura ("Apertura", Range(0.0, 1)) = 0.5 
        _rangeOfLight ("factor de intensidad", Range(0.0, 1)) = 0.05 

        _AmbientLightColor("Color Luz Ambiente", Color) = (1, 1, 1, 1)
        _MaterialKa("MaterialKa", Vector) = (0.24725,0.2245,0.0645,1)
        _MaterialKd("MaterialKd", Vector) = (0.34615,0.3143,0.0903,1)
        _MaterialKs("MaterialKs", Vector) = (0.79735,0.72399,0.208006,1)
        _Material_n("Material_n", Range(1,100)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            sampler2D _MainTex;

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 position : POSITION;
                float3 normal : NORMAL; // object coordinates
            };

            struct v2f
            {
                float4 position_w : TEXCOORD0; //world
                float4 position : SV_POSITION; //clipping
                float3 normal : TEXCOORD1; //world space

            };

            float4 _LightIntensity_d;
            float4 _LightIntensity_s;
            float4 _LightIntensity_a;
            float4 _Puntual_Position_w;
            float4 _MaterialKa;
            float4 _MaterialKd;
            float4 _MaterialKs;
            float _Material_n;
            float4 _Directional_Position_w; 
            float4 _Spot_Position_w;
            float4 _SpotColor;
            float4 _Spot_Direction_w;
            float  _Apertura, _rangeOfLight;
            float4 _PuntualColor;
            float4 _DirectionalColor;
            float4 _MaterialColor;
            float4 _AmbientLightColor;


            v2f vert (appdata v)
            {
                v2f output;
                output.position = UnityObjectToClipPos(v.position);
                output.position_w = mul(unity_ObjectToWorld, v.position);
                output.normal = UnityObjectToWorldNormal(v.normal);
                return output;
            }

            fixed4 frag (v2f f) : SV_Target
            {

                //Para más luces debería ahcer sumatorias del termino difuso y el termino especular
                
                float4 fragColor = 0;

                //Simulación, color pelado
                float3 ambient = 0;
                ambient = _LightIntensity_a * _MaterialKa*_AmbientLightColor;


                float distanc = 0;


                //Iluminación puntual
                //fatt factor de atenuación
                float3 luzPuntual = 0;
                float3 L = normalize(_Puntual_Position_w.xyz - f.position_w.xyz); //coordenada del mundo
                float3 N = normalize(f.normal);
                float lambertian =max(dot(L,N),0);
                //1 es la atenuación, la atenuación podría ser igual al modulo de L sin normalizar
                distanc = distance(_Puntual_Position_w.xyz, f.position_w.xyz);
                float3 factorAtenuacionPuntual= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc));
                luzPuntual =_MaterialKd*lambertian*_PuntualColor; //difusapuntual


                //Direccional
                float3 LDireccional = normalize(-_Directional_Position_w );
                distanc = distance(_Directional_Position_w.xyz, f.position_w.xyz);
                float3 factorAtenuacionDireccional= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) ); 
                float3 luzDireccional = max(0, dot(N,LDireccional))*_DirectionalColor*_MaterialKd.rgb; //difusa Direccional

                //spot
                float3 Lspot = normalize(_Spot_Position_w.xyz - f.position_w.xyz); 
                float3 LspotDir = normalize(_Spot_Direction_w); 
                distanc = distance(_Spot_Position_w.xyz, f.position_w.xyz);
                float3 factorAtenuacionSpot= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc));            
                


                float3 luzSpot = 0;
                float cosenoDelAnguloEntreElObjetoYLaLuz = dot(Lspot,LspotDir);
                if (cosenoDelAnguloEntreElObjetoYLaLuz> _Apertura){
                    float intensidad = max(dot(N,Lspot),0);
                    if(intensidad > 0){
                        luzSpot= intensidad * _SpotColor * _SpotColor*_MaterialKd.rgb; //difusa spot 
                    }                        
                }


                //brillo del objeto debido a la luz
                //más n, más se concentra el brillo en un punto, más chico el brillo es más distribuído
                float3 specular = 0;
                float specCoeff = 0;

                    
                    
                float3 V= normalize(_WorldSpaceCameraPos - f.position_w); //coordenada del mundo
                
                //Phong
                float3 R= reflect(-L,N);
                float specAngle =max(dot(R,V),0);

                
                specCoeff =pow(specAngle, _Material_n);

                //specular= _LightIntensity_d*_MaterialKs*specCoeff;

                //componentes especulares de cada luz

                //puntual
                float3 specularPuntual = _PuntualColor*_MaterialKs.rgb*specCoeff;

                //direccional
                float3 specularLuzDireccional = _DirectionalColor*_MaterialKs*specCoeff;

                //spot
                float3 specularLuzSpot = _SpotColor*_MaterialKs.rgb*specCoeff;

                

                //fragColor.rgb = ambient+diffuse+specular;
                fragColor.rgb = (luzPuntual+specularPuntual)* factorAtenuacionPuntual *_LightIntensity_d.rgb + (luzDireccional+specularLuzDireccional)*factorAtenuacionDireccional*_LightIntensity_d.rgb  + (luzSpot+specularLuzSpot) * factorAtenuacionSpot *_LightIntensity_d.rgb + ambient;
                //fragColor.rgb = fragColor.rgb* _MaterialColor;
                //fragColor.rgb = ambient;
                //fragColor.rgb=fragColor.rgb*_MaterialColor;
                return fragColor* _MaterialColor;
            }
            ENDCG
        }
    }
}
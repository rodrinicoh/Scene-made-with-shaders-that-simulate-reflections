Shader "Unlit/Lightning-diffuseTextureFragment"
{
    Properties
    {

        //[NoScaleOffset] _MainTex ("Texture", 2D) = "white" {} //en _MainTex se guarda la textura
        _MaterialColor ("Material Color", Color) = (0.25, 0.5, 0.5, 1)
        
        //Spot
        _Spot_Position_w ("Ubicacion Luz Spot", Vector) = (0, 5, 0, 1)
        _Spot_Direction_w ("Direccion Luz Spot", Vector) = (0, 5, 0, 1)
        _SpotColor ("Color Luz Spot", Color) = (0.25, 0.5, 0.5, 1)
        _Apertura ("Apertura", Range(0.0, 1)) = 0.5 
        _rangeOfLight ("factor de intensidad", Range(0.0, 1)) = 0.05 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
            sampler2D _MainTex;

            #include "UnityCG.cginc"

            struct vertexData
            {
                float4 position : POSITION; //coordenadas objeto
                float3 normal : NORMAL;//coordenadas objeto
            };

            struct v2f
            {
                float4 position : SV_POSITION; //coordenadas clipping
                float4 positionworld : TEXCOORD1;
                float3 normal : TEXCOORD0; //world space
            };

            float4 _LightPosition_w;
            float4 _MaterialColor;
            float4 _Spot_Position_w;
            float4 _SpotColor;
            float4 _Spot_Direction_w;
            float  _Apertura,_radius, _rangeOfLight;

            v2f vertexShader(vertexData v)
            {
                float4 position_w = mul(unity_ObjectToWorld, v.position);
                float3 normal_w = normalize(UnityObjectToWorldNormal(v.normal));
                v2f output;
                output.position = UnityObjectToClipPos(v.position);
                output.positionworld = position_w;
                output.normal = normal_w;

                return output;
            }

            fixed4 fragmentShader(v2f f) : SV_Target
            {
                float3 N = f.normal;
                float3 Lspot = normalize(_Spot_Position_w.xyz - f.positionworld.xyz); 
                float3 LspotDir = normalize(_Spot_Direction_w); 
                float distanc = distance(_Spot_Position_w.xyz, f.positionworld.xyz);
                float factorAtenuacionSpot = 1;
                factorAtenuacionSpot = (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc));            
                

                fixed4 fragColor = 0;
                float4 luzSpot = 0;
                float cosenoDelAnguloEntreElObjetoYLaLuz = dot(Lspot,LspotDir);
                if (cosenoDelAnguloEntreElObjetoYLaLuz> _Apertura){
                    float intensidad = max(dot(N,Lspot),0);
                    if(intensidad > 0){
                        luzSpot= intensidad * factorAtenuacionSpot* _MaterialColor * _SpotColor; 
                    }                        
                }

                return fragColor = luzSpot;

                /*
                float3 L = normalize(_LightPosition_w.xyz - f.positionworld.xyz);
                float3 Sd = normalize(-_LightPosition_w.xyz);
                float3 N = f.normal;
                float4 spec=(0,0,0,0);

                float intensity = 0;
                float anguloDelCono= dot(Sd,L);
                if( anguloDelCono > 90){
                    intensity = max(0, dot(N,L));
                    if (intensity>0.0){
                        float3 V = normalize(_WorldSpaceCameraPos - f.positionworld.xyz);
                        float3 H= normalize(L+V);
                        float intSpec = max(dot(H,N),0.0);
                        spec = specular_*pow(intSpec,shininess_);
                    }
                }
                
                float4 fragColor = 0;
                fixed4 col = tex2D(_MainTex, f.uv); //en función a una coordenada de la textura nos retorna el color
                fragColor.rgb=max(intensity * diffuse_+spec,col);

                return fragColor;*/
            }
            ENDCG
        }
    }
}

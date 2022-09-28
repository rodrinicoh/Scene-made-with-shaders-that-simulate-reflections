Shader "Unlit/ShaderCompleto"
{
    Properties
    {
        _MaterialColor ("Material Color", Color) = (0.25, 0.5, 0.5, 1)

        //Direccional
        _Directional_Position_w ("Direccion Luz Direccional", Vector) = (0, 5, 0, 1)
        _DirectionalColor ("Color Luz Direccional", Color) = (0.25, 0.5, 0.5, 1)

        //Puntual
        _Puntual_Position_w ("Ubicacion Luz Puntual", Vector) = (0, 5, 0, 1)
        _PuntualColor ("Color Luz Puntual", Color) = (0.25, 0.5, 0.5, 1)

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

        Pass{
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
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

            float4 _MaterialColor;
            float4 _Directional_Position_w;
            float4 _Puntual_Position_w;
            float4 _DirectionalColor;
            float4 _PuntualColor;
            float4 _Spot_Position_w;
            float4 _SpotColor;
            float4 _Spot_Direction_w;
            float  _Apertura, _rangeOfLight;


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
 
            fixed4 fragmentShader (v2f f) : SV_Target{

                float3 N = f.normal;

                //Direccional
                float3 Ldireccional = normalize(-1 * _Directional_Position_w.xyz);      
                float diffDireccional = max(0, dot(N, Ldireccional));
                float3 luzDireccional = diffDireccional * _MaterialColor * _DirectionalColor;

                //Puntual
                float3 Lpuntual = normalize(_Puntual_Position_w.xyz - f.positionworld.xyz); 
                float distanc = distance(_Puntual_Position_w.xyz, f.positionworld.xyz);
                float factorAtenuacionPuntual = (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc) + (_rangeOfLight*distanc*distanc)); 
                float diffPuntual = max(0, dot(N, Lpuntual)* factorAtenuacionPuntual);
                float3 luzPuntual = diffPuntual * _MaterialColor * _PuntualColor;

                //Spot
                float3 Lspot = normalize(_Spot_Position_w.xyz - f.positionworld.xyz); 
                float3 LspotDir = normalize(_Spot_Direction_w); 
                distanc = distance(_Spot_Position_w.xyz, f.positionworld.xyz);
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


                //Suma
                fragColor.rgb = (luzPuntual) + (luzDireccional) + (luzSpot);
                
                return fragColor;
            }
            ENDCG
        }
    }
}

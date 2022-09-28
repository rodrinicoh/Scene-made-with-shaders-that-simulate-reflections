Shader "Unlit/CookYTorranceDireccional"
{
    Properties
    {
        _MaterialColor ("Material Color", Color) = (1, 1, 1, 1)

        //Puntual
        _DirectionalPosition_w ("Ubicacion Luz Direccional", Vector) = (0, 5, 0, 1)
        _DirectionalColor ("Color Luz Direccional", Color) = (0.25, 0.5, 0.5, 1)

        //difuso
        _MaterialKd("MaterialKd", Vector) = (0.34615,0.3143,0.0903,1)
        _LightIntensity_d("LightIntensity_d", Color) = (1,1,1,1) //Ip

        _rangeOfLight ("factor de intensidad", Range(0.0, 1)) = 0.05

        
        roughness ("Roughness (alfa)", Range (0.0,1.0)) = 0.5
        fresnel ("fresnel (F0)", Range (0.0,1.0)) = 0.5

        _MaterialKd("MaterialKd", Vector) = (0.34615,0.3143,0.0903,1)
        _MaterialKa("MaterialKa",Vector) = (0.34615,0.34615,0.34615,0)
        _LightIntensity_d("LightIntensity_d", Color) = (1,1,1,1) //Ip
        _MaterialKs("MaterialKs", Vector) = (0.79735,0.72399,0.208006,1)

        _AmbientLight("AmbientLight",Color) = (1,1,1,1)
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

            float4 _DirectionalPosition_w;
            float4 _DirectionalColor;
            float4 _MaterialColor;
            float roughness;
            float _rangeOfLight;
            float3 _LightIntensity_d;
            float fresnel;
            
            float4 _MaterialKd;
            float4 _MaterialKs;
            float4 _MaterialKa;
            float4 _AmbientLight;
            static const float PI = 3.14159265358979323846;

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

            

            fixed4 fragmentShader(v2f i) : SV_Target
            {

                float3 ambient =  _AmbientLight * _MaterialKa;
                float3 N = normalize(i.normal);
                float3 L = normalize(-_DirectionalPosition_w.xyz );
                float3 V= normalize(_WorldSpaceCameraPos - i.positionworld); //coordenada del mundo
                float3 H = normalize((L+V));

                float NdotL = max(dot(N,L),0.0);
                float NdotV = max(dot(N,V),0.0);

                float NdotH = max(dot(N,H),0.0);
                float LdotH = max(dot(L,H),0.0);
                float HdotV = max(dot(H,V),0.0);

                /*
                // Diffuse fresnel
                float FL,FV;
                float m = clamp(1-NdotL, 0, 1);
                float m2 = m*m;
                FL=m2*m2*m; //pow 5

                m=clamp(1-NdotV, 0, 1);
                m2 = m*m;
                FV=m2*m2*m;//pow 5

                float Fd90 = 0.5 + 2 * LdotH*LdotH * roughness;
                float F = lerp(1.0, Fd90, FL) * lerp(1.0, Fd90, FV);*/

                //F
                //float F0 = pow((refraction-1),2)/pow((refraction+1),2); //diap 114
                float m = clamp(1-HdotV, 0, 1);
                float Fpow=pow(m,5); //pow 5
                //float F=F0+(1-F0)*Fpow;
                float F=fresnel+(1-fresnel)*Fpow;

                //G
                float G = min(min (1,(2*NdotH*NdotL)/HdotV), (2*NdotH*NdotV)/HdotV); //diap 129
                

                //D
                float arriba = 1/(PI*pow(roughness,2)*pow(NdotH,4));
                //float D = pow( (1/(PI*pow(roughness,2)*pow(NdotH,4))) , (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));//diap 123
                float D = arriba* exp( (pow(NdotH,2)-1)/(pow(roughness,2)*pow(NdotH,2)));

                float cookTorranceSinDifuso = (F*D*G)/(4*NdotL*NdotV);

                float3 cookTorrance =cookTorranceSinDifuso*_LightIntensity_d;//POR QUE IBA MULTIPLICADO POR EL LIGHT INTENSITY ACA?
                

                //difuso
                float distanc = distance(_DirectionalPosition_w.xyz, i.positionworld.xyz);
                float3 factorAtenuacionDireccional= (1.0f) / (_rangeOfLight + (_rangeOfLight*distanc));
                float3 specularLuzDireccional = _DirectionalColor*_MaterialKs.rgb*cookTorranceSinDifuso; //o deberia ser con G?

                float3 luzDireccionalDifusa = NdotL*_DirectionalColor*_MaterialKd.rgb*factorAtenuacionDireccional; //difusa Direccional


                float3 luzDireccional = luzDireccionalDifusa+specularLuzDireccional;
                fixed4 fragColor = 0;
                fragColor.rgb= (luzDireccional+cookTorrance+ambient)*_MaterialColor;
                return fragColor;
            }
            ENDCG
        }
    }
}








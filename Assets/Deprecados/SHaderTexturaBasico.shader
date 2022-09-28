Shader "Unlit/Lightning-diffuseTextureFragment"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {} //en _MainTex se guarda la textura
        _MaterialColor ("Material Color", Color) = (0.25, 0.5, 0.5, 1)
        _LightColor ("Light Color", Color) = (1, 1,1, 1)
        _LightPosition_w ("Light Position (WORLD)", Vector) = (0, 5, 0, 1)
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
                float2 uv : TEXCOORD0; //coordenada de ,  float2 es un vector de 4 componentes y el tipo de cada componente es TEXTCORD0
            };

            struct v2f
            {
                float4 position : SV_POSITION; //coordenadas clipping
                float4 positionworld : TEXCOORD1;
                float3 normal : TEXCOORD0; //world space
                float2 uv : TEXCOORD2; //coordenada de textura
            };

            float4 _LightPosition_w;
            float4 _MaterialColor;
            float4 _LightColor;

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

            fixed4 fragmentShader(v2f f) : SV_Target
            {
                float3 L = normalize(_LightPosition_w.xyz - f.positionworld.xyz);
                float3 N = f.normal;

                float diffCoef = max(0, dot(N,L));
                float4 fragColor = 0;
                fixed4 col = tex2D(_MainTex, f.uv); //en función a una coordenada de la textura nos retorna el color
                fragColor.rgb=diffCoef * _MaterialColor*col*_LightColor;

                return fragColor;
            }
            ENDCG
        }
    }
}

Shader "Custom/LuzDireccionalComun"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _MaterialColor ("Material Color", Color) = (0.25, 0.5, 0.5, 1)
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
                float3 L = normalize(-_LightPosition_w.xyz );
                float3 N = f.normal;

                float diffCoef = max(0, dot(N,L));
                float4 fragColor = 0;
                fragColor.rgb=diffCoef * _MaterialColor;

                return fragColor;
            }
            ENDCG
        }
    }
}

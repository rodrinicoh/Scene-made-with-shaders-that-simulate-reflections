Shader "Unlit/TexturaBasico"
{


    //https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
    //https://docs.unity3d.com/Manual/SL-ShaderSemantics.html
    //The Properties block contains shader variables (textures, colors etc.) that will be saved as part of the Material, and displayed in the material inspector. In our unlit shader template, there is a single texture property declared.
    Properties 
    {
         _MaterialColor ("Material Color", Color) = (0.25, 0.5, 0.5, 1)
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata //datos que vienen desde la app
            {
                float4 vertex : POSITION; //posición de vertice,  float4 es un vector de 4 componentes y el tipo de cada componente es POSITION
            };

            struct v2f //shader de vertice a shader de fragmento
            {
                float4 vertex : SV_POSITION; // clip space position
            };

            float3 _MaterialColor ;

            //Por cada vertice ejecuto
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); //Transforms a point from object space to the camera’s clip space in homogeneous coordinates.
                return o;
            }

            
            //Por cada fragmento ejecuto
            fixed4 frag (v2f i) : SV_Target
            {
                float4 fragColor = 0;
                fragColor.rgb=_MaterialColor;
                return fragColor;
            }
            ENDCG
        }
    }
}

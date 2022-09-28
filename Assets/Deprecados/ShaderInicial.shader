Shader "Unlit/ShaderInicial"
{


    //https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
    //https://docs.unity3d.com/Manual/SL-ShaderSemantics.html
    //The Properties block contains shader variables (textures, colors etc.) that will be saved as part of the Material, and displayed in the material inspector. In our unlit shader template, there is a single texture property declared.
    Properties 
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {} //en _MainTex se guarda la textura
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            sampler2D _MainTex;

            #include "UnityCG.cginc"

            struct appdata //datos que vienen desde la app
            {
                float4 vertex : POSITION; //posición de vertice,  float4 es un vector de 4 componentes y el tipo de cada componente es POSITION
                float2 uv : TEXCOORD0; //coordenada de ,  float2 es un vector de 4 componentes y el tipo de cada componente es TEXTCORD0
            };

            struct v2f //shader de vertice a shader de fragmento
            {
                float2 uv : TEXCOORD0; //coordenada de textura
                float4 vertex : SV_POSITION; // clip space position
            };

            //Por cada vertice ejecuto
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); //Transforms a point from object space to the camera’s clip space in homogeneous coordinates.
                o.uv = v.uv;
                return o;
            }

            
            //Por cada fragmento ejecuto
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv); //en función a una coordenada de la textura nos retorna el color
                return col;
            }
            ENDCG
        }
    }
}

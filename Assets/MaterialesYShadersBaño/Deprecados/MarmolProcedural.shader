Shader "MarmolProcedural"
{
	Properties
	{
		_ku("ku", Range(2,500)) = 30
		_kv("kv", Range(2,500)) = 30
		_Density("Density", Range(2,500)) = 30
		_MaterialColor ("Material Color", Color) = (1, 1, 1, 1)
	}
		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float _Density;
			float _ku;
			float _kv;
			float4 _MaterialColor;

			float2 random2(float2 st) {
				st = float2(dot(st, float2(127.1, 311.7)),
					dot(st, float2(269.5, 183.3)));
				return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
			}

			float noise(float2 st) {
				float2 i = floor(st);
				float2 f = frac(st);

				float2 u = f * f * f * (f * (f * 6. - 15.) + 10.);
				return lerp(lerp(dot(random2(i + float2(0.0, 0.0)), f - float2(0.0, 0.0)),
					dot(random2(i + float2(1.0, 0.0)), f - float2(1.0, 0.0)), u.x),
					lerp(dot(random2(i + float2(0.0, 1.0)), f - float2(0.0, 1.0)),
						dot(random2(i + float2(1.0, 1.0)), f - float2(1.0, 1.0)), u.x), u.y);
			}

			float turbulencia(float2 vvv)
            {
                float fr = 10.0f;
                float fg = 5.0f;
                float fb = 2.5f;
                float fa = 1.25f;
                return abs(noise(fr * vvv) - 0.5) +
                    abs(noise(fg * vvv) - 0.5) +
                    abs(noise(fb * vvv) - 0.5) +
                    abs(noise(fa * vvv) - 0.5);
            }

            float2 random(float2 st) {
            st = float2(dot(st,float2(127.1,311.7)),
                      dot(st,float2(269.5,183.3)));
            return -1.0 + 2.0 * frac(sin(st) * 43758.5453123);
            }

            // Gradient Noise by Inigo Quilez - iq/2013
            // https://www.shadertoy.com/view/XdXGW8
            float perlinNoise(float2 st) {
                float2 i = floor(st);
                float2 f = frac(st);

                //float2 u = f*f*(3.0-2.0*f);
                float2 u = f * f * f * (f * (f * 6. - 15.) + 10.);
                return lerp(lerp(dot(random(i + float2(0.0,0.0)), f - float2(0.0,0.0)),
                                dot(random(i + float2(1.0,0.0)), f - float2(1.0,0.0)), u.x),
                            lerp(dot(random(i + float2(0.0,1.0)), f - float2(0.0,1.0)),
                                dot(random(i + float2(1.0,1.0)), f - float2(1.0,1.0)), u.x), u.y);
            }

			float marble(float u, float v)
			{
				float f = 0.0;
				f = turbulencia(float2(u, v));
				f = 0.5 + 0.5 * f;
				return sin(_ku * u + _kv * v+ _Density*f);
			}


            

			v2f vert(float4 pos : POSITION, float2 uv : TEXCOORD0)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(pos);
				o.uv = uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 fragColor = 0;
				float c=marble(i.uv.x,i.uv.y);
				//fragColor = fixed4(c*255+139,c*255+69,c*255+19, 1.0);
				fragColor = fixed4(c,c,c, 1.0);
				fragColor=fragColor*_MaterialColor;
				

				return fragColor;
			}
			ENDCG
		}
	}
}
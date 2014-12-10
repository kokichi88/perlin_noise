
Shader "Noise/PerlinNoise1D" 
{
	Properties 
	{
	}
	SubShader 
	{
		Blend One One
		
    	Pass 
    	{
    		ZTest Always Cull Off ZWrite Off
      		Fog { Mode off }

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			
			struct a2v 
			{
    			float4  pos : SV_POSITION;
    			float2  uv : TEXCOORD0;
			};

			struct v2f 
			{
    			float4  pos : SV_POSITION;
    			float2  uv : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
    			v2f OUT;
    			OUT.pos = mul(UNITY_MATRIX_MVP, v.pos);
    			OUT.uv = v.uv;
    			return OUT;
			}
			
			uniform sampler2D _Perm;
			uniform float _Frq;
			uniform float _Amp;
			uniform  float _Gain;
			uniform float2 _TexSize;
			
			float FADE(float t) { return t * t * t * ( t * ( t * 6.0f - 15.0f ) + 10.0f ); }
	
			int PERM(int i)
			{
				return tex2D(_Perm, float2((float)i/255.0f, 0.0)).a * 255.0f;
			}
			
			float GRAD1(int hash, float x ) 
			{
				int h = hash % 16;
				float grad = 1.0f + (h % 8);
				if((h%8) < 4) grad = -grad;
				return ( grad * x );
			}
			
			float NOISE1D( float x )
			{
				//returns a noise value between -0.5 and 0.5
			    int ix0, ix1;
			    float fx0, fx1;
			    float s, n0, n1;
			
			    ix0 = floor(x); 		// Integer part of x
			    fx0 = x - ix0;       	// Fractional part of x
			    fx1 = fx0 - 1.0f;
			    ix1 = ( ix0+1 ) % 256;
			    ix0 = ix0 % 256;    	// Wrap to 0..255
				
			    s = FADE(fx0);
			
			    n0 = GRAD1(PERM(ix0), fx0);
			    n1 = GRAD1(PERM(ix1), fx1);

			    return 0.188f * lerp(n0, n1, s);
			}
			
			half4 frag(v2f IN) : COLOR
			{
				float2 pos = IN.uv * _TexSize;
				
				float noise = NOISE1D(pos.x*_Gain/_Frq) * _Amp/_Gain;
	
				return half4(noise,noise,noise,1.0f);
			}
			
		ENDCG

    	}
	}
}
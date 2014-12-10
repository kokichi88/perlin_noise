
Shader "Noise/PerlinNoise2D" 
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
	
			float LERP(float t, float a, float b) { return (a) + (t)*((b)-(a)); }
			
			int PERM(int i)
			{
				return tex2D(_Perm, float2((float)i/255.0f, 0.0)).a * 255.0f;
			}
			
			float GRAD2(int hash, float x, float y)
			{
				int h = hash % 16;
		    	float u = h<4 ? x : y;
		    	float v = h<4 ? y : x;
				int hn = h % 2;
				int hm = (h/2) % 2;
		    	return ((hn != 0) ? -u : u) + ((hm != 0) ? -2.0f*v : 2.0f*v);
			}
			
			float NOISE2D(float x, float y)
			{
				//returns a noise value between -0.75 and 0.75
				int ix0, iy0, ix1, iy1;
			    float fx0, fy0, fx1, fy1, s, t, nx0, nx1, n0, n1;
			    
			    ix0 = floor(x); 		// Integer part of x
			    iy0 = floor(y); 		// Integer part of y
			    fx0 = x - ix0;        	// Fractional part of x
			    fy0 = y - iy0;        	// Fractional part of y
			    fx1 = fx0 - 1.0f;
			    fy1 = fy0 - 1.0f;
			    ix1 = (ix0 + 1) % 256; 	// Wrap to 0..255
			    iy1 = (iy0 + 1) % 256;
			    ix0 = ix0 % 256;
			    iy0 = iy0 % 256;
			    
			   	t = FADE( fy0 );
	    		s = FADE( fx0 );
	    		
	    		nx0 = GRAD2(PERM(ix0 + PERM(iy0)), fx0, fy0);
			    nx1 = GRAD2(PERM(ix0 + PERM(iy1)), fx0, fy1);
				
			    n0 = lerp(nx0, nx1, t);
			
			    nx0 = GRAD2(PERM(ix1 + PERM(iy0)), fx1, fy0);
			    nx1 = GRAD2(PERM(ix1 + PERM(iy1)), fx1, fy1);
				
			    n1 = lerp(nx0, nx1, t);
			
			    return 0.507f * lerp(n0, n1, s);
			    
			}
			
			half4 frag(v2f IN) : COLOR
			{
				float2 pos = IN.uv * _TexSize;
				
				float noise = NOISE2D(pos.x*_Gain/_Frq, pos.y*_Gain/_Frq) * _Amp/_Gain;
	
				return half4(noise,noise,noise,1.0f);
			}
			
		ENDCG

    	}
	}
}
using UnityEngine;
using System.Collections;

public class ExampleCPU : MonoBehaviour {
	public int seed  = 0;
	public int octaves  = 8;
	public float frq   = 50.0f;
	public float amp   = 1.0f;
	public int width  = 512;
	public int height  = 512;
	public Color startColor;
	public Color endColor;
	public Texture2D startText;
	public Texture2D endText;
	public float speed = 0.1f;
	private float max = 1;
	private float cur = 0;
	private PerlinNoise perlin ;
	private float[] grayScale;
	private Texture2D texture;
	void Start() 
	{
		
		perlin = new PerlinNoise(Random.Range(0, int.MaxValue));
		
		grayScale = new float[width * height];
		texture = new Texture2D(width, height, TextureFormat.RGB24, false);
		for (int y  = 0; y < height; ++y) 
		{
			for (int x  = 0; x < width; ++x) 
			{
				//Example of 1D noise
				//int noise = perlin.FractalNoise1D(x, octaves, frq, amp);
				
				//Example of 2D noise
				float noise = perlin.FractalNoise2D(x, y, octaves, frq, amp);
				
				//Example of 3D noise
//				float noise = perlin.FractalNoise3D(x, y, Time.deltaTime, octaves, frq, amp);
				
				//Noise is roughly in the range of -1 to 1. Convert to a range of 0 - 1
				noise = (noise + 1.0f) * 0.5f;
				grayScale[y * width + x] = noise;
//				texture.SetPixel(x,y, Color.Lerp(Color.black, Color.white, noise * x / height * y / width));
			}
		}
		renderer.material.mainTexture = texture;
//		texture.Apply();
//		Updaxte();
	}

	void Update()
	{
		if(cur > max ) return;
		cur += speed * Time.deltaTime;
		float low = cur;
		float high = low + speed * Time.deltaTime;
		float[] temp = AdjustLevel(grayScale,low, high);
//		float[] temp = grayScale;
		for (int y  = 0; y < height; ++y) 
		{
			for (int x  = 0; x < width; ++x) 
			{
				startColor = startText.GetPixel(x,y);
				endColor = endText.GetPixel(x,y);
				texture.SetPixel(x,y, Color.Lerp(startColor,endColor, 1 - temp[y * width + x]));
			}
		}
		texture.Apply();
	}

	private float[] AdjustLevel(float[] grayScale, float low, float high)
	{
		float[] ret = new float[width * height];
		for (int y  = 0; y < height; ++y) 
		{
			for (int x  = 0; x < width; ++x) 
			{
				int index = y * width + x;
				float scale = grayScale[index];
				
				if (scale <= low)
				{
					ret[index] = 0;
				}
				else if (scale >= high)
				{
					ret[index] = 1;
				}
				else
				{
					ret[index] = (scale - low) / (high - low);
				}
			}
		}
		return ret;
	}
}

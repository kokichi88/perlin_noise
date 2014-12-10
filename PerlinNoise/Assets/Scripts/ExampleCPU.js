#pragma strict

var seed : int = 0;
var octaves : int = 8;
var frq : float = 50.0;
var amp : float = 1.0;
var width : int = 512;
var height : int = 512;

private var perlin : PerlinNoise;

function Start() 
{

	perlin = new PerlinNoise(seed);
	
    var texture = new Texture2D(width, height, TextureFormat.RGB24, false);
   	guiTexture.texture = texture;
   	
    for (var y : int = 0; y < texture.height; ++y) 
    {
        for (var x : int = 0; x < texture.width; ++x) 
        {
        	//Example of 1D noise
        	//var noise = perlin.FractalNoise1D(x, octaves, frq, amp);
        	
        	//Example of 2D noise
			var noise = perlin.FractalNoise2D(x, y, octaves, frq, amp);
			
			//Example of 3D noise
			//var noise = perlin.FractalNoise3D(x, y, Time.deltaTime, octaves, frq, amp);
			
			//Noise is roughly in the range of -1 to 1. Convert to a range of 0 - 1
			noise = (noise + 1.0) * 0.5;
			
			texture.SetPixel(x, y, Color(noise,noise,noise,1.0));
        }
    }
    
    texture.Apply();
  
}






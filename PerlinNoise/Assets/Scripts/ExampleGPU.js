#pragma strict

var renderTex : RenderTexture;
var shader1D : Shader;
var shader2D : Shader;

var seed : int = 0;
var octaves : int = 8;
var frq : float = 50.0;
var amp : float = 1.0;

function Start() 
{
    
    var perlin = new PerlinNoise(seed);
 	perlin.LoadPermTableIntoTexture();
 	
// 	renderTex.format = RenderTextureFormat.ARGBHalf;
 	
   	perlin.RenderIntoTexture(shader2D, renderTex, octaves, frq, amp);
   	
}

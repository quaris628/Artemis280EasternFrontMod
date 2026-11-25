
// shader by Thom Robertson

//*************************************************************************
sampler2D tex0: register(s0) = sampler_state {
//    FILTER = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp; //Wrap;
};


//*************************************************************************
/* data passed from vertex shader to pixel shader */
struct vertexOutput {
    float4 HPosition	: POSITION;
    float2 UV		: TEXCOORD0;

};
 


//*************************************************************************
uniform extern float4 inputSetA: register(C0);

////*************************************************************************
//float4 backPS(vertexOutput IN) : COLOR 
//{
//    float3 diffuseColor = tex2D(tex0,IN.UV).rgb;
//    return float4(diffuseColor,1);
//}

//*************************************************************************
// inputSetA.x   = light radius (3.0 is good)
// inputSetA.y   = light intensity
// inputSetA.z   = light source in U
// inputSetA.w   = light source in V
float4 mainPS(vertexOutput IN) : COLOR 
{
	float ds;
    float3 diffuseColor = tex2D(tex0,IN.UV).rgb;
    if (any(diffuseColor))
    {
		ds = (IN.UV.x - inputSetA.z)*(IN.UV.x - inputSetA.z)  +
		     (IN.UV.y - inputSetA.w)*(IN.UV.y - inputSetA.w);
		ds = clamp((1-ds*inputSetA.x)*inputSetA.y,0,0.1);
		
	    diffuseColor.r = ds;
		diffuseColor.g = ds;
		diffuseColor.b = ds;
	}
	else
	{
	    diffuseColor.r = 0;
		diffuseColor.g = 0;
		diffuseColor.b = 0;
	}
    return float4(diffuseColor,1);
}

//*************************************************************************
technique Main 
{

//	pass p0 
//	{
//		CullMode    = None;
//		SrcBlend    = ONE;
//		DestBlend   = ONE;
//		PixelShader = compile ps_2_0 backPS();
//	}
	
	pass p0 
	{
		CullMode         = None;
		SrcBlend         = ONE;
		DestBlend        = ONE;
		ShadeMode        = FLAT;
		BlendOp          = ADD;
		AlphaBlendEnable = True;
		PixelShader = compile ps_2_0 mainPS();
	}
}

// end of file

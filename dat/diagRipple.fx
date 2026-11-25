// shader by Thom Robertson

//*******************************************************************
sampler2D tex0: register(s0) = sampler_state {
//    Texture = tex1;
//    FILTER = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp; //Wrap;
};

//*******************************************************************
/* data passed from vertex shader to pixel shader */
struct vertexOutput {
    float4 HPosition	: POSITION;
    float2 UV		: TEXCOORD0;

};
 


uniform extern float4 inputSetA: register(C0);

// inputSetA.x  = ripple position, -1.2 to 1.1
// inputSetA.y  = ripple depth, good is 0.008
//*******************************************************************
float4 mainPS(vertexOutput IN) : COLOR 
{
	float ripple = IN.UV.x + IN.UV.y + inputSetA.x;

	float displaceAmount = 0;
	if (ripple >= 0.8 && ripple <= 0.9)
		displaceAmount = (ripple - 0.8) / 0.1 * inputSetA.y;
	if (ripple > 0.9 && ripple <= 1.0)
		displaceAmount = (1-ripple) / 0.1 * inputSetA.y;


	float2 offset = IN.UV;
	offset.x -= displaceAmount;
	offset.y -= displaceAmount;
   float3 diffuseColor = tex2D(tex0,offset).rgb;
    return float4(diffuseColor,1);
}

//*******************************************************************
technique Main 
{

	pass p0 
	{
		CullMode = None;
		PixelShader = compile ps_2_0 mainPS();
	}
}

// end of file

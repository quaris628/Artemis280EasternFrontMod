
// shader by Thom Robertson

//*************************************************************************
sampler2D tex0: register(s0) = sampler_state {
//    FILTER = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp; //Wrap;
};


//*************************************************************************
sampler2D tex1: register(s1) = sampler_state {
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
float4 mainPS(vertexOutput IN) : COLOR 
{
    float3 diffuseColor = tex2D(tex0,IN.UV).rgb;
    return float4(diffuseColor, tex2D(tex1,IN.UV).a);
}

//*************************************************************************
technique Main 
{

	pass p0 
	{
		CullMode    = None;
		PixelShader = compile ps_2_0 mainPS();
	}
}

// end of file

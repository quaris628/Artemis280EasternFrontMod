
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

const float3 lumMult = {0.3, 0.59, 0.11};

//*************************************************************************
float4 mainPS(vertexOutput IN) : COLOR 
{
    float3 diffuseColor  = tex2D(tex0,IN.UV).rgb;
//	float lum = dot(diffuseColor, lumMult);
	float lum = diffuseColor.r * 0.3 + diffuseColor.g * 0.59 + diffuseColor.b * 0.11; //dot(diffuseColor, lumMult);
	diffuseColor = lum;

//    return float4(diffuseColor,1);
    return float4(diffuseColor * lum,1);
}

//*************************************************************************
technique Main 
{

	pass p0 
	{
		CullMode    = None;
//		SrcBlend    = ONE;
//		DestBlend   = ONE;
		PixelShader = compile ps_2_0 mainPS();
	}
}

// end of file

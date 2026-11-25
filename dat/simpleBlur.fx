
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

//*************************************************************************
float4 mainPS(vertexOutput IN) : COLOR 
{
    
    float2 texelSize;
    float2 coord = IN.UV;
    texelSize.x = 1/inputSetA.x;
    texelSize.y = 1/inputSetA.y;

//    coord.x += texelSize.x*2;
//    coord.y += texelSize.y*2;

    float3 diffuseColor  = tex2D(tex0,coord).rgb;
    coord.x -= texelSize.x;
    diffuseColor        += tex2D(tex0,coord).rgb;
    coord.x += texelSize.x;
    coord.y -= texelSize.y;
    diffuseColor        += tex2D(tex0,coord).rgb;
    coord.x += texelSize.x;
    coord.y += texelSize.y;
    diffuseColor        += tex2D(tex0,coord).rgb;
    coord.x -= texelSize.x;
    coord.y += texelSize.y;
    diffuseColor        += tex2D(tex0,coord).rgb;
    coord.y += texelSize.y;

    diffuseColor        += tex2D(tex0,coord).rgb;
    coord.x += texelSize.x*2;
    coord.y -= texelSize.y*2;
    diffuseColor        += tex2D(tex0,coord).rgb;
    coord.x += texelSize.x*2;
    coord.y += texelSize.y*2;
    diffuseColor        += tex2D(tex0,coord).rgb;
    coord.x -= texelSize.x*2;
    coord.y += texelSize.y*2;
    diffuseColor        += tex2D(tex0,coord).rgb;
    
	diffuseColor /= 9;
    return float4(diffuseColor,1);
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

// shader by Thom Robertson

sampler2D tex0: register(s0) = sampler_state {
//    Texture = tex1;
//    FILTER = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp; //Wrap;
};
sampler2D tex1: register(s1) = sampler_state {
//    Texture = tex1;
//    FILTER = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp; //Wrap;
}; 

float4x4 WorldViewProj : WorldViewProjection;
/*
sampler2D ColorSampler = sampler_state {
    Texture = tex1;
//    FILTER = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp; //Wrap;
};  
*/
/* data from application vertex buffer */
struct appdata {
    float3 Position	: POSITION;
    float4 UV		: TEXCOORD0;

};

/* data passed from vertex shader to pixel shader */
struct vertexOutput {
    float4 HPosition	: POSITION;
    float2 UV		: TEXCOORD0;

};
 

vertexOutput mainVS(appdata IN) 
{
    vertexOutput OUT;// = (vertexOutput)0;
	OUT.HPosition.xyz = IN.Position;
	OUT.HPosition.w   = 0;
	OUT.UV            = IN.UV;
    return OUT;
}
//float4 mainVS(float3 pos : POSITION) : POSITION{
//	return mul(float4(pos.xyz, 1.0), WorldViewProj);
//}

uniform extern float4 inputSetA: register(C0);

float4 mainPS(vertexOutput IN) : COLOR 
{
	float2 offset = IN.UV;

	offset.x += inputSetA.z-0.5;
	offset.y += inputSetA.w-0.5;

	offset.x -= 0.5;
	offset.x *= inputSetA.x;
	offset.x += 0.5;
	offset.y -= 0.5;
	offset.y *= inputSetA.x;
	offset.y += 0.5;


   float3 dispColor = tex2D(tex1,offset).rgb;

	IN.UV.x += ((dispColor.r-0.5) * inputSetA.y);
	IN.UV.y += ((dispColor.g-0.5) * inputSetA.y);
   float3 diffuseColor = tex2D(tex0,IN.UV).rgb;

	float colorChange = abs(dispColor.g-0.5) * 0.1;
	colorChange += abs(dispColor.r-0.5) * 0.1;

	diffuseColor.b += colorChange;

   return float4(diffuseColor,1);
}

technique Main 
{

	pass p0 
	{
		CullMode = None;
		VertexShader = compile vs_2_0 mainVS();
		PixelShader = compile ps_2_0 mainPS();
	}
}

// end of file

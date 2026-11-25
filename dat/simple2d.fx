/*

% Description of my shader.
% Second line of description for my shader.

keywords: material classic

date: YYMMDD

*/

sampler2D tex0: register(s0);

float4x4 WorldViewProj : WorldViewProjection;
/*
sampler2D ColorSampler = sampler_state {
    Texture = <ColorTexture>;
//    FILTER = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
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

float4 mainPS(vertexOutput IN) : COLOR 
{
	float alp = 0;
    float3 diffuseColor = tex2D(tex0,IN.UV).rgb;
	if (diffuseColor.r > 0 ||
		diffuseColor.g > 0 ||
	    diffuseColor.b > 0)
	   alp = 1;
    return float4(diffuseColor,alp);
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

/*

shader for Artemis skybox

*/

sampler2D tex0;

float4x4 wvp : WorldViewProjection;

float brightness = 0;

/* data from application vertex buffer */
struct appdata {
    float4 Position	: POSITION;
    float4 UV		: TEXCOORD0;

};

/* data passed from vertex shader to pixel shader */
struct vertexOutput {
    float4 Position	: POSITION;
    float2 UV		: TEXCOORD0;

};
 

vertexOutput mainVS(appdata IN) 
{
    vertexOutput OUT;
	OUT.Position = mul(IN.Position,wvp);
	OUT.UV            = IN.UV;
    return OUT;
}

float4 mainPS(vertexOutput IN) : COLOR 
{
    float4 diffuseColor = tex2D(tex0,IN.UV) * brightness;
 //   diffuseColor.r = 1;
 //   diffuseColor.g = 0;
 //   diffuseColor.b = 0;
    diffuseColor.a = 1;
    return diffuseColor;
}

technique Main 
{
	pass p0 
	{
		//CullMode = None;
		VertexShader = compile vs_2_0 mainVS();
		PixelShader = compile ps_2_0 mainPS();
	}
}

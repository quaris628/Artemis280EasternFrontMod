float4x4 wvp : WorldViewProjection;

float4 DiffuseColor : Diffuse = float4(1,1,1,1);

struct VS_IN
{
	float4 Position : POSITION;
	float3 Normal : NORMAL;
};

struct VS_OUT
{
	float4 Position : POSITION;
};

struct PS_OUT
{
	float4 Color : COLOR;
};

VS_OUT VS_AmbientDiffuse(VS_IN input)
{
	VS_OUT output = (VS_OUT)0;
	output.Position = mul(input.Position,wvp);
	
	return output;
}

PS_OUT PS_AmbientDiffuse(VS_OUT input)
{
	PS_OUT output = (PS_OUT)0;
	
	output.Color = DiffuseColor;
	
	return output;
}

technique Main
{
	pass Pass0
	{
		AlphaBlendEnable = TRUE;
		BlendOp = ADD;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
		
		VertexShader = compile vs_2_0 VS_AmbientDiffuse();
		PixelShader = compile ps_2_0 PS_AmbientDiffuse();
	}
}
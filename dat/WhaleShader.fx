
//----------------------------------------
//----------------------------------------

float4x4 wvp : WorldViewProjection;

float4 DiffuseColor : Diffuse = float4(1,1,1,1);
float waveValue : waveValue;

float3 DirectionToEye : DirectionToEye; 


struct VS_IN
{
	float4 Position : POSITION;
	float3 Normal : NORMAL;
};

struct VS_OUT
{
	float4 Position : POSITION;
	float4 Color    : COLOR0;
};

struct PS_OUT
{
	float4 Color : COLOR;
};

//----------------------------------------
VS_OUT VS_AmbientDiffuse(VS_IN input)
{
	VS_OUT output = (VS_OUT)0;
	input.Position.y = input.Position.y + sin(waveValue+input.Position.z/100) * input.Position.z/6;
	output.Position = mul(input.Position,wvp);
	
	output.Color.a = (1 - pow(dot(DirectionToEye, input.Normal), 2.0)) * 0.3;
	
	return output;
}

//----------------------------------------
PS_OUT PS_AmbientDiffuse(VS_OUT input)
{
	PS_OUT output = (PS_OUT)0;
	
	output.Color = DiffuseColor;
	output.Color.a = input.Color.a;
	
	return output;
}

//----------------------------------------
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
float4x4 wvp : WorldViewProjection;
float4x4 world : World;

float3 CameraPosition : CameraPosition; 

float AmbientIntensity = 1;
float4 AmbientColor : AMBIENT = float4(0.1,0.1,0.1,1);

//**********************************************************************
float3 LightDirection : Direction = float3(0,1,1);

//**********************************************************************
texture ColorMap : Diffuse;
sampler ColorMapSampler = sampler_state 
{
    texture = <ColorMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
};

//**********************************************************************
texture GlowMap : Diffuse;
sampler GlowMapSampler = sampler_state 
{
    texture = <GlowMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
};

//**********************************************************************
texture ReflectionMap : Diffuse;
sampler ReflectionMapSampler = sampler_state
{
    texture = <ReflectionMap>;   
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
};


//**********************************************************************
struct VS_IN
{
	float4 Position : POSITION;
	float2 TexCoord : TEXCOORD0;
	float3 Normal : NORMAL;	
};

//**********************************************************************
struct VS_OUT
{
	float4 Position : POSITION;
	float2 TexCoord : TEXCOORD0;
	float3 Light : TEXCOORD1;
    float3 CamView : TEXCOORD2;
    float4 posS : TEXCOORD3;
    float3 Normal : TEXCOORD4;	
};

//**********************************************************************
struct PS_OUT
{
	float4 Color : COLOR;
};

//**********************************************************************
float3x3 QuaternionToMatrix(float4 quat)
{
    float3 cross = quat.yzx * quat.zxy;
    float3 square= quat.xyz * quat.xyz;
    float3 wimag = quat.w * quat.xyz;

    square = square.xyz + square.yzx;

    float3 diag = 0.5 - square;
    float3 a = (cross + wimag);
    float3 b = (cross - wimag);

    return float3x3(
    2.0 * float3(diag.x, b.z, a.y),
    2.0 * float3(a.z, diag.y, b.x),
    2.0 * float3(b.y, a.x, diag.z));
}

uniform extern float4 inputSetA: register(C0);

//**********************************************************************
//**********************************************************************
VS_OUT VS_ColorGlowMap(VS_IN input)
{
	VS_OUT output = (VS_OUT)0;
	
	output.Position = mul(input.Position,wvp);	
	output.Light = LightDirection;
	output.TexCoord = input.TexCoord;

    float4 PosWorld = mul(input.Position,world);
    output.CamView = CameraPosition - mul(input.Position,world);
    output.posS = input.Position;
    
	output.Normal = mul(input.Normal,world);
	
	return output;
}

//**********************************************************************
//**********************************************************************
PS_OUT PS_ColorGlowMap(VS_OUT input)
{
	PS_OUT output = (PS_OUT)0;
	
	float3 LightDir = normalize(input.Light);
	float Diffuse = saturate(dot(LightDir,normalize(input.Normal)));
		
	float4 texCol = tex2D(ColorMapSampler,input.TexCoord);
	float4 glowCol = tex2D(GlowMapSampler,input.TexCoord);
	float4 Ambient = AmbientIntensity * AmbientColor;
	
    float3 root3 = float3(0.57735, 0.57735, 0.57735);
    float half_angle = 0.5 * radians(3.0); // Hue is radians of 0 tp 360 degree
    float4 rot_quat = float4( (root3 * sin(half_angle)), cos(half_angle));
    float3x3 rot_Matrix = QuaternionToMatrix(rot_quat);
    if (glowCol.r > glowCol.g && glowCol.r > glowCol.b && glowCol.r > 0.1) // if r is the dominant color
    {
	    glowCol.rgb = inputSetA.rgb * glowCol.r;
	    texCol.rgb = (texCol.rgb + inputSetA.rgb)/2;
	}	
			
	float4 glow = glowCol * saturate(1-Diffuse);	
	
    texCol *= Diffuse;
    float3 Half = normalize(normalize(LightDirection) + normalize(input.CamView));   
    float specular = pow(saturate(dot(normalize(input.Normal),Half)),25);
    float4 specCol = 2 * tex2D(ReflectionMapSampler,input.TexCoord) * (specular * Diffuse);	

	output.Color =  Ambient + texCol + glow + specCol;
//	output.Color =  Ambient + specCol;
	
	return output;
}

//**********************************************************************
technique ColorGlowMap
{
	pass Pass0
	{
		VertexShader = compile vs_2_0 VS_ColorGlowMap();
		PixelShader = compile ps_2_0 PS_ColorGlowMap();
	}
}
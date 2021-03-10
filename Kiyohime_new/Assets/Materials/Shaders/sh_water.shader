// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_water"
{
	Properties
	{
		_Offset("Offset", Vector) = (0,0,0,0)
		[Normal]_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		_NoiseScale("NoiseScale", Float) = 0
		_Noise2Scale("Noise2Scale", Float) = 0
		_TexturePower("TexturePower", Float) = 0
		_NormalPower("NormalPower", Float) = 0
		_NormDir("NormDir", Vector) = (0,0,0,0)
		_NoiseSpeed("NoiseSpeed", Vector) = (0,0,0,0)
		_Noise2Speed("Noise2Speed", Vector) = (0,0,0,0)
		[HDR]_NoiseColor("NoiseColor", Color) = (0,0.7686275,2,1)
		[HDR]_Noise2Color("Noise2Color", Color) = (0,0.7686275,2,1)
		[HDR]_TextColor("TextColor", Color) = (0,0.7686275,2,1)
		_MainTex("_MainTex", 2D) = "white" {}
		_SmoothStep("SmoothStep", Vector) = (0,1,0,0)
		_tiling("tiling", Vector) = (0,0,0,0)
		_TillingLinewave("Tilling Line wave", Vector) = (0,0,0,0)
		_OffsetUV("Offset UV", Vector) = (0,0,0,0)
		_OffsetShape("Offset Shape", Float) = 0
		_OffsetLine("Offset Line", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex.SampleBias(samplerTex,coord,bias)
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex.SampleGrad(samplerTex,coord,ddx,ddy)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex2Dbias(tex,float4(coord,0,bias))
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex2Dgrad(tex,coord,ddx,ddy)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard alpha:fade keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_TextureSample0);
		uniform float2 _tiling;
		uniform float3 _NormDir;
		SamplerState sampler_TextureSample0;
		uniform float _NormalPower;
		uniform float2 _OffsetUV;
		uniform float2 _TillingLinewave;
		uniform float _OffsetShape;
		uniform float _OffsetLine;
		uniform float4 _TextColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
		SamplerState sampler_MainTex;
		uniform float2 _Offset;
		uniform float _TexturePower;
		uniform float2 _SmoothStep;
		uniform float _NoiseScale;
		uniform float3 _NoiseSpeed;
		uniform float4 _NoiseColor;
		uniform float _Noise2Scale;
		uniform float3 _Noise2Speed;
		uniform float4 _Noise2Color;


		float2 MyCustomExpression135( float2 uv, float u_time, float2 u_resolution, float OffsetShape, float OffsetLine )
		{
			uv = uv/ u_resolution;
			float curve = 0.02 * sin((9.25 * uv.x) + (2.0 * u_time));
			float curve2 = 0.02 * sin((9.25 * (uv.x -0.3)) + (2.0 * u_time));
			float lineAShape = smoothstep(1.0 - clamp(distance(curve + (uv.y+OffsetLine), OffsetShape) *1.0, 0.0, 1.0), 1.0,0.99);
			float lineAShape2 = smoothstep(1.0 - clamp(distance(curve2 + (uv.y+OffsetLine), OffsetShape) *1.0, 0.0, 1.0), 1.0,0.99);
			float ShapeAShape = smoothstep(1.0 - clamp(distance(curve + uv.y, OffsetShape) * 1.0, 0.0, 1.0), 1.0, 0.7);
			float subsLine = (lineAShape - (1 -lineAShape2));
			float  lineAGrey = (1.0 - subsLine);
			return float2(ShapeAShape,lineAGrey);
		}


		float2 voronoihash66( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi66( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash66( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		float2 voronoihash104( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi104( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash104( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 vertexDes52 = float4( 0,0,0,0 );
			v.vertex.xyz += vertexDes52.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord42 = i.uv_texcoord * _tiling + ( _Time.y * _NormDir ).xy;
			float3 Normal50 = ( UnpackNormal( SAMPLE_TEXTURE2D( _TextureSample0, sampler_TextureSample0, uv_TexCoord42 ) ) * _NormalPower );
			o.Normal = Normal50;
			float2 uv_TexCoord136 = i.uv_texcoord + _OffsetUV;
			float2 uv135 = uv_TexCoord136;
			float u_time135 = _Time.y;
			float2 u_resolution135 = _TillingLinewave;
			float OffsetShape135 = _OffsetShape;
			float OffsetLine135 = _OffsetLine;
			float2 localMyCustomExpression135 = MyCustomExpression135( uv135 , u_time135 , u_resolution135 , OffsetShape135 , OffsetLine135 );
			float2 break144 = localMyCustomExpression135;
			float temp_output_3_0_g5 = ( break144.y - 0.1 );
			float2 appendResult10_g2 = (float2(1.0 , 1.0));
			float2 temp_output_11_0_g2 = ( abs( (i.uv_texcoord*2.0 + -1.0) ) - appendResult10_g2 );
			float2 break16_g2 = ( 1.0 - ( temp_output_11_0_g2 / fwidth( temp_output_11_0_g2 ) ) );
			float2 uv_TexCoord25 = i.uv_texcoord * _tiling + _Offset;
			float lerpResult91 = lerp( saturate( min( break16_g2.x , break16_g2.y ) ) , SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, ( uv_TexCoord25 * _TexturePower ) ).a , _TexturePower);
			float texture27 = lerpResult91;
			float time66 = _Time.x;
			float2 uv_TexCoord60 = i.uv_texcoord * _tiling + ( _Time.x * _NoiseSpeed ).xy;
			float2 coords66 = uv_TexCoord60 * _NoiseScale;
			float2 id66 = 0;
			float2 uv66 = 0;
			float fade66 = 0.5;
			float voroi66 = 0;
			float rest66 = 0;
			for( int it66 = 0; it66 <8; it66++ ){
			voroi66 += fade66 * voronoi66( coords66, time66, id66, uv66, 0 );
			rest66 += fade66;
			coords66 *= 2;
			fade66 *= 0.5;
			}//Voronoi66
			voroi66 /= rest66;
			float smoothstepResult75 = smoothstep( _SmoothStep.x , _SmoothStep.y , voroi66);
			float Noise64 = smoothstepResult75;
			float temp_output_74_0 = ( texture27 + Noise64 );
			float time104 = _Time.x;
			float2 uv_TexCoord101 = i.uv_texcoord * _tiling + ( _Time.x * _Noise2Speed ).xy;
			float2 coords104 = uv_TexCoord101 * _Noise2Scale;
			float2 id104 = 0;
			float2 uv104 = 0;
			float fade104 = 0.5;
			float voroi104 = 0;
			float rest104 = 0;
			for( int it104 = 0; it104 <8; it104++ ){
			voroi104 += fade104 * voronoi104( coords104, time104, id104, uv104, 0 );
			rest104 += fade104;
			coords104 *= 2;
			fade104 *= 0.5;
			}//Voronoi104
			voroi104 /= rest104;
			float Noise2106 = voroi104;
			o.Albedo = ( saturate( ( temp_output_3_0_g5 / fwidth( temp_output_3_0_g5 ) ) ) + ( ( _TextColor * texture27 ) + ( temp_output_74_0 * _NoiseColor ) + ( Noise2106 * _Noise2Color ) ) ).rgb;
			float temp_output_3_0_g4 = ( break144.x - 0.1 );
			float temp_output_148_0 = saturate( ( temp_output_3_0_g4 / fwidth( temp_output_3_0_g4 ) ) );
			o.Alpha = ( temp_output_148_0 * temp_output_74_0 );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
734;73;806;635;1767.356;198.555;2.830024;True;False
Node;AmplifyShaderEditor.CommentaryNode;56;-3087.803,1474.078;Inherit;False;1380.147;484.9896;Comment;9;64;66;60;67;59;57;58;75;96;Noise2;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;26;-3184.137,-738.8909;Inherit;False;1854.85;609.8881;texture;9;27;91;81;89;77;78;25;21;22;texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;22;-3133.395,-562.5992;Inherit;False;Property;_Offset;Offset;1;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;110;-3818.024,858.2667;Inherit;False;Property;_tiling;tiling;16;0;Create;True;0;0;False;0;False;0,0;10,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;57;-3032.803,1599.448;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;58;-3028.426,1735.279;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;9;0;Create;True;0;0;False;0;False;0,0,0;-0.1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;97;-3074.745,2076.732;Inherit;False;1381.147;528.9896;Comment;7;104;106;102;101;100;99;98;Noise2;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2777.13,1725.078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-2946.947,-642.1378;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;78;-2863.442,-217.4763;Inherit;False;Property;_TexturePower;TexturePower;6;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;99;-3019.745,2202.103;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;98;-3015.368,2337.934;Inherit;False;Property;_Noise2Speed;Noise2Speed;10;0;Create;True;0;0;False;0;False;0,0,0;-1.01,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-2638.53,1527.478;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-2606.638,1741.62;Inherit;False;Property;_NoiseScale;NoiseScale;4;0;Create;True;0;0;False;0;False;0;8.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2637.646,-645.1129;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;48;-3069.414,16.07494;Inherit;False;1531.073;486.2009;Comment;8;50;43;42;41;47;40;79;95;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;66;-2392.735,1583.386;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-2764.072,2327.733;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;89;-2351.718,-459.2262;Inherit;True;Property;_MainTex;_MainTex;14;0;Create;True;0;0;False;0;False;-1;None;8cc7a1e5d9a5fd34da29d2486ea0d693;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;96;-2186.961,1811.388;Inherit;False;Property;_SmoothStep;SmoothStep;15;0;Create;True;0;0;False;0;False;0,1;0.13,0.83;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;81;-2297.955,-685.7898;Inherit;True;Rectangle;-1;;2;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;47;-3010.037,277.2758;Inherit;False;Property;_NormDir;NormDir;8;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;91;-1854.908,-581.8856;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;40;-3019.414,117.4452;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-2625.472,2130.133;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;102;-2593.58,2344.275;Inherit;False;Property;_Noise2Scale;Noise2Scale;5;0;Create;True;0;0;False;0;False;0;17.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;75;-2164.486,1588.349;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.28;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;142;-1368.33,1367;Inherit;False;Property;_OffsetUV;Offset UV;18;0;Create;True;0;0;False;0;False;0,0;0.35,0.58;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-2743.741,201.0749;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VoronoiNode;104;-2367.677,2185.041;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1650.142,-592.2935;Inherit;False;texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-1942.774,1586.071;Inherit;True;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1150.16,-35.44173;Inherit;True;27;texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-2545.141,115.4748;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1189.122,160.1781;Inherit;True;64;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1929.715,2188.726;Inherit;True;Noise2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-1162.429,1989.136;Inherit;False;Property;_OffsetShape;Offset Shape;19;0;Create;True;0;0;False;0;False;0;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;136;-1177.323,1341.846;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;147;-1147.442,2081.479;Inherit;False;Property;_OffsetLine;Offset Line;20;0;Create;True;0;0;False;0;False;0;-0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;139;-1182.335,1841.736;Inherit;False;Property;_TillingLinewave;Tilling Line wave;17;0;Create;True;0;0;False;0;False;0,0;0.07,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;134;-1193.792,1166.253;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;108;-1214.157,780.5062;Inherit;False;Property;_Noise2Color;Noise2Color;12;1;[HDR];Create;True;0;0;False;0;False;0,0.7686275,2,1;0.3915094,1,0.5062761,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;135;-867.446,1478.792;Inherit;False;uv = uv/ u_resolution@$float curve = 0.02 * sin((9.25 * uv.x) + (2.0 * u_time))@$float curve2 = 0.02 * sin((9.25 * (uv.x -0.3)) + (2.0 * u_time))@$float lineAShape = smoothstep(1.0 - clamp(distance(curve + (uv.y+OffsetLine), OffsetShape) *1.0, 0.0, 1.0), 1.0,0.99)@$$float lineAShape2 = smoothstep(1.0 - clamp(distance(curve2 + (uv.y+OffsetLine), OffsetShape) *1.0, 0.0, 1.0), 1.0,0.99)@$$float ShapeAShape = smoothstep(1.0 - clamp(distance(curve + uv.y, OffsetShape) * 1.0, 0.0, 1.0), 1.0, 0.7)@$$float subsLine = (lineAShape - (1 -lineAShape2))@$float  lineAGrey = (1.0 - subsLine)@$$return float2(ShapeAShape,lineAGrey)@;2;False;5;True;uv;FLOAT2;0,0;In;;Inherit;False;True;u_time;FLOAT;0;In;;Inherit;False;True;u_resolution;FLOAT2;0,0;In;;Inherit;False;True;OffsetShape;FLOAT;0;In;;Inherit;False;True;OffsetLine;FLOAT;0;In;;Inherit;False;My Custom Expression;True;False;0;5;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;73;-830.2976,418.7693;Inherit;False;Property;_NoiseColor;NoiseColor;11;1;[HDR];Create;True;0;0;False;0;False;0,0.7686275,2,1;0,0.3679245,0.1754372,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;107;-1162.617,589.8466;Inherit;True;106;Noise2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-2149.454,269.4601;Inherit;False;Property;_NormalPower;NormalPower;7;0;Create;True;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;93;-958.6454,-176.4928;Inherit;False;Property;_TextColor;TextColor;13;1;[HDR];Create;True;0;0;False;0;False;0,0.7686275,2,1;0,0.02674794,0.02377595,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-917.0075,193.5302;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-2260.442,66.07494;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;1;[Normal];Create;True;0;0;False;0;False;-1;None;dd2fd2df93418444c8e280f1d34deeb5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-661.8804,-65.90729;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;144;-616.3582,1482.12;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;54;-3084.024,617.5085;Inherit;False;1330.941;704.3287;VertexDisp;9;15;14;12;18;36;34;35;31;52;VertexDisp;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-937.8489,722.3192;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-553.9897,360.5823;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-1914.641,123.258;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-1750.409,229.4628;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;148;-342.5405,1435.729;Inherit;False;Step Antialiasing;-1;;4;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0.1;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-344.5582,72.97503;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-1997.083,859.8426;Inherit;False;vertexDes;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;150;-308.8928,1578.589;Inherit;False;Step Antialiasing;-1;;5;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0.1;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;18;-3027.136,667.5085;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-562.2888,228.8079;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;154;-896.694,2270.538;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.38;False;2;FLOAT;0.9999;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;-129.8872,35.62169;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-2661.293,821.0988;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;15;-3034.024,936.7644;Inherit;False;Property;_offset;offset;0;0;Create;True;0;0;False;0;False;0,0,0;0,0.05,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinTimeNode;14;-2896.464,1124.705;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;146;-65.95819,1450.64;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-243.2636,282.6204;Inherit;False;52;vertexDes;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-320.1475,-140.0262;Inherit;False;50;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;-426.7923,1674.29;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2704.284,1068.838;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-591.0199,1982.161;Inherit;False;Property;_Float0;Float 0;23;0;Create;True;0;0;False;0;False;0;5.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;-412.1671,1840.215;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-2649.593,696.2986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;-2213.513,857.6752;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;21;-3134.137,-688.8909;Inherit;False;Property;_Tilling;Tilling;2;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-2661.293,932.8989;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;151;-1216.524,2255.703;Inherit;True;Property;_NoiseVariationLine;Noise Variation Line;21;0;Create;True;0;0;False;0;False;-1;None;b6aade3184b6cf0408b479908ac52f8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;158;-777.1374,1749.528;Inherit;True;Property;_TextureSample1;Texture Sample 1;22;0;Create;True;0;0;False;0;False;-1;None;b6aade3184b6cf0408b479908ac52f8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;sh_water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;0;57;1
WireConnection;59;1;58;0
WireConnection;25;0;110;0
WireConnection;25;1;22;0
WireConnection;60;0;110;0
WireConnection;60;1;59;0
WireConnection;77;0;25;0
WireConnection;77;1;78;0
WireConnection;66;0;60;0
WireConnection;66;1;57;1
WireConnection;66;2;67;0
WireConnection;100;0;99;1
WireConnection;100;1;98;0
WireConnection;89;1;77;0
WireConnection;91;0;81;0
WireConnection;91;1;89;4
WireConnection;91;2;78;0
WireConnection;101;0;110;0
WireConnection;101;1;100;0
WireConnection;75;0;66;0
WireConnection;75;1;96;1
WireConnection;75;2;96;2
WireConnection;41;0;40;2
WireConnection;41;1;47;0
WireConnection;104;0;101;0
WireConnection;104;1;99;1
WireConnection;104;2;102;0
WireConnection;27;0;91;0
WireConnection;64;0;75;0
WireConnection;42;0;110;0
WireConnection;42;1;41;0
WireConnection;106;0;104;0
WireConnection;136;1;142;0
WireConnection;135;0;136;0
WireConnection;135;1;134;0
WireConnection;135;2;139;0
WireConnection;135;3;143;0
WireConnection;135;4;147;0
WireConnection;74;0;28;0
WireConnection;74;1;71;0
WireConnection;43;1;42;0
WireConnection;94;0;93;0
WireConnection;94;1;28;0
WireConnection;144;0;135;0
WireConnection;109;0;107;0
WireConnection;109;1;108;0
WireConnection;72;0;74;0
WireConnection;72;1;73;0
WireConnection;79;0;43;0
WireConnection;79;1;95;0
WireConnection;50;0;79;0
WireConnection;148;2;144;0
WireConnection;92;0;94;0
WireConnection;92;1;72;0
WireConnection;92;2;109;0
WireConnection;150;2;144;1
WireConnection;145;0;148;0
WireConnection;145;1;74;0
WireConnection;154;0;151;1
WireConnection;149;0;150;0
WireConnection;149;1;92;0
WireConnection;36;0;18;2
WireConnection;36;1;12;0
WireConnection;146;0;148;0
WireConnection;146;1;144;1
WireConnection;157;0;144;1
WireConnection;157;2;159;0
WireConnection;12;0;15;2
WireConnection;12;1;14;4
WireConnection;159;0;158;1
WireConnection;159;1;160;0
WireConnection;34;0;18;1
WireConnection;34;1;15;1
WireConnection;31;0;34;0
WireConnection;31;1;36;0
WireConnection;31;2;35;0
WireConnection;35;0;18;3
WireConnection;35;1;15;3
WireConnection;0;0;149;0
WireConnection;0;1;51;0
WireConnection;0;9;145;0
WireConnection;0;11;53;0
ASEEND*/
//CHKSM=DDB58AA32896666CE037A7BED2594BC9519A0856
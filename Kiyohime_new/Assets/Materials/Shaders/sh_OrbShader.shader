// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_OrbShader"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		[HDR]_Color2("Color 2", Color) = (0,4.924578,0.7724828,1)
		_ColorPrincipal("Color Principal", Color) = (0.5773503,0.5773503,0.5773503,1)
		[HDR]_Color3("Color 3", Color) = (0.5773503,0.5773503,0.5773503,1)
		_RadialStrenthCenter("RadialStrenthCenter", Vector) = (0,0,1,1)
		_ribbonPower("ribbonPower", Float) = 2
		_radial("radial", Vector) = (0,0,0,0)
		_UV_Speed("UV_Speed", Float) = 0.1
		_VoroSpeed("VoroSpeed", Float) = 1.85
		_voroScale("voroScale", Float) = 1
		_VoroTiling("VoroTiling", Vector) = (1,1,0,0)
		_BorderSpeed("BorderSpeed", Float) = 0.2
		[HDR]_MainTex("_MainTex", 2D) = "white" {}
		_Metalicness("Metalicness", Float) = 1
		_RADIAL_STRENGTH("RADIAL_STRENGTH", Vector) = (1,1,0,0)
		_FILL("FILL", Range( 0 , 1)) = 0.5805688
		_SmoothStep("SmoothStep", Float) = 1
		_VoroStrength("VoroStrength", Float) = 10
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
		uniform float4 _MainTex_ST;
		SamplerState sampler_MainTex;
		uniform float4 _Color3;
		uniform float _BorderSpeed;
		uniform float4 _RadialStrenthCenter;
		uniform float _FILL;
		uniform float _SmoothStep;
		uniform float _VoroStrength;
		uniform float4 _ColorPrincipal;
		uniform float _ribbonPower;
		uniform float _voroScale;
		uniform float _VoroSpeed;
		uniform float2 _VoroTiling;
		uniform float _UV_Speed;
		uniform float2 _radial;
		uniform float4 _Color2;
		uniform float2 _RADIAL_STRENGTH;
		uniform float _Metalicness;
		uniform float _EdgeLength;


		float2 voronoihash321( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi321( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash321( n + g );
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


		float2 voronoihash323( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi323( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash323( n + g );
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


		float2 voronoihash315( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi315( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash315( n + g );
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


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1);
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1);
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		float2 voronoihash112( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi112( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash112( n + g );
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


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float2 voronoihash154( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi154( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash154( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.707 * sqrt(dot( r, r ));
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash187( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi187( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash187( n + g );
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
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float time321 = 1.0;
			float2 appendResult296 = (float2(( ( _BorderSpeed * _Time.y ) + i.uv_texcoord.x ) , i.uv_texcoord.y));
			float2 coords321 = appendResult296 * 1.0;
			float2 id321 = 0;
			float2 uv321 = 0;
			float fade321 = 0.5;
			float voroi321 = 0;
			float rest321 = 0;
			for( int it321 = 0; it321 <8; it321++ ){
			voroi321 += fade321 * voronoi321( coords321, time321, id321, uv321, 0 );
			rest321 += fade321;
			coords321 *= 2;
			fade321 *= 0.5;
			}//Voronoi321
			voroi321 /= rest321;
			float time323 = 0.5;
			float2 coords323 = i.uv_texcoord * 1.0;
			float2 id323 = 0;
			float2 uv323 = 0;
			float fade323 = 0.5;
			float voroi323 = 0;
			float rest323 = 0;
			for( int it323 = 0; it323 <8; it323++ ){
			voroi323 += fade323 * voronoi323( coords323, time323, id323, uv323, 0 );
			rest323 += fade323;
			coords323 *= 2;
			fade323 *= 0.5;
			}//Voronoi323
			voroi323 /= rest323;
			float time315 = 0.0;
			float2 coords315 = i.uv_texcoord * 2.0;
			float2 id315 = 0;
			float2 uv315 = 0;
			float fade315 = 0.5;
			float voroi315 = 0;
			float rest315 = 0;
			for( int it315 = 0; it315 <8; it315++ ){
			voroi315 += fade315 * voronoi315( coords315, time315, id315, uv315, 0 );
			rest315 += fade315;
			coords315 *= 2;
			fade315 *= 0.5;
			}//Voronoi315
			voroi315 /= rest315;
			float3 temp_cast_0 = (( voroi321 + voroi323 + voroi315 )).xxx;
			float grayscale320 = Luminance(temp_cast_0);
			float2 temp_output_1_0_g10 = SampleGradient( (Gradient)0, i.uv_texcoord.y ).rg;
			float2 appendResult135 = (float2(_RadialStrenthCenter.x , ( _FILL + -1.0 )));
			float2 uv_TexCoord128 = i.uv_texcoord + appendResult135;
			float2 temp_output_11_0_g10 = ( temp_output_1_0_g10 - uv_TexCoord128 );
			float2 break18_g10 = temp_output_11_0_g10;
			float2 appendResult19_g10 = (float2(break18_g10.y , -break18_g10.x));
			float dotResult12_g10 = dot( temp_output_11_0_g10 , temp_output_11_0_g10 );
			float2 appendResult136 = (float2(_RadialStrenthCenter.z , _RadialStrenthCenter.w));
			float2 temp_output_132_0 = ( temp_output_1_0_g10 + ( appendResult19_g10 * ( dotResult12_g10 * appendResult136 ) ) + float2( 0,0 ) );
			float grayscale160 = Luminance(float3( ( grayscale320 + temp_output_132_0 ) ,  0.0 ));
			float smoothstepResult252 = smoothstep( ( 1.0 - grayscale160 ) , _SmoothStep , grayscale160);
			float time112 = ( _Time.x * 0.1 );
			float2 coords112 = appendResult296 * 1.0;
			float2 id112 = 0;
			float2 uv112 = 0;
			float fade112 = 0.5;
			float voroi112 = 0;
			float rest112 = 0;
			for( int it112 = 0; it112 <8; it112++ ){
			voroi112 += fade112 * voronoi112( coords112, time112, id112, uv112, 0 );
			rest112 += fade112;
			coords112 *= 2;
			fade112 *= 0.5;
			}//Voronoi112
			voroi112 /= rest112;
			Gradient gradient125 = NewGradient( 0, 3, 2, float4( 0, 0, 0, 0.3499962 ), float4( 1, 1, 1, 0.5000076 ), float4( 0, 0, 0, 0.6500038 ), 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float temp_output_148_0 = ( _VoroSpeed * _SinTime.x );
			float time154 = temp_output_148_0;
			float4 appendResult223 = (float4(( _Time.y * _UV_Speed ) , 0.0 , 0.0 , 0.0));
			float2 uv_TexCoord152 = i.uv_texcoord * _VoroTiling + appendResult223.xy;
			float2 coords154 = uv_TexCoord152 * _voroScale;
			float2 id154 = 0;
			float2 uv154 = 0;
			float voroi154 = voronoi154( coords154, time154, id154, uv154, 0 );
			float2 temp_cast_4 = (( _ribbonPower * voroi154 )).xx;
			float2 temp_output_1_0_g15 = temp_cast_4;
			float2 temp_output_1_0_g14 = i.uv_texcoord;
			float2 temp_output_11_0_g14 = ( temp_output_1_0_g14 - _radial );
			float2 break18_g14 = temp_output_11_0_g14;
			float2 appendResult19_g14 = (float2(break18_g14.y , -break18_g14.x));
			float dotResult12_g14 = dot( temp_output_11_0_g14 , temp_output_11_0_g14 );
			float2 temp_cast_5 = (temp_output_148_0).xx;
			float2 temp_output_214_0 = ( temp_output_1_0_g14 + ( appendResult19_g14 * ( dotResult12_g14 * float2( 10,10 ) ) ) + temp_cast_5 );
			float2 temp_output_11_0_g15 = ( temp_output_1_0_g15 - temp_output_214_0 );
			float2 break18_g15 = temp_output_11_0_g15;
			float2 appendResult19_g15 = (float2(break18_g15.y , -break18_g15.x));
			float dotResult12_g15 = dot( temp_output_11_0_g15 , temp_output_11_0_g15 );
			float grayscale159 = Luminance(SampleGradient( gradient125, ( temp_output_1_0_g15 + ( appendResult19_g15 * ( dotResult12_g15 * temp_output_214_0 ) ) + temp_output_214_0 ).x ).rgb);
			float4 temp_cast_8 = (grayscale159).xxxx;
			float4 temp_output_139_0 = ( grayscale159 * _Color2 );
			o.Albedo = ( SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, uv_MainTex ) * ( ( ( ( _Color3 * grayscale160 * ( 1.0 - smoothstepResult252 ) ) + ( ( ( voroi112 * _VoroStrength ) + smoothstepResult252 ) * _ColorPrincipal ) ) - temp_cast_8 ) + temp_output_139_0 ) ).rgb;
			o.Emission = temp_output_139_0.rgb;
			float time187 = 1.0;
			float2 temp_output_1_0_g16 = i.uv_texcoord;
			float2 temp_output_11_0_g16 = ( temp_output_1_0_g16 - float2( 0.5,0.5 ) );
			float2 break18_g16 = temp_output_11_0_g16;
			float2 appendResult19_g16 = (float2(break18_g16.y , -break18_g16.x));
			float dotResult12_g16 = dot( temp_output_11_0_g16 , temp_output_11_0_g16 );
			float2 temp_output_181_0 = ( temp_output_1_0_g16 + ( appendResult19_g16 * ( dotResult12_g16 * _RADIAL_STRENGTH ) ) + float2( 0,0 ) );
			float2 appendResult349 = (float2(( _Time.x * 10.0 ) , 0.0));
			float2 uv_TexCoord351 = i.uv_texcoord * temp_output_181_0 + appendResult349;
			float2 coords187 = ( temp_output_181_0 + uv_TexCoord351 ) * 0.5;
			float2 id187 = 0;
			float2 uv187 = 0;
			float fade187 = 0.5;
			float voroi187 = 0;
			float rest187 = 0;
			for( int it187 = 0; it187 <8; it187++ ){
			voroi187 += fade187 * voronoi187( coords187, time187, id187, uv187, 0 );
			rest187 += fade187;
			coords187 *= 2;
			fade187 *= 0.5;
			}//Voronoi187
			voroi187 /= rest187;
			float details197 = ( 2.0 * voroi187 );
			o.Metallic = ( details197 * _Metalicness );
			float opacity369 = grayscale160;
			o.Alpha = ( details197 * opacity369 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
-1920;2;1920;1019;97.2146;2867.503;2.02482;True;True
Node;AmplifyShaderEditor.TimeNode;298;-3449.067,-2315.357;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;297;-3432.715,-2460.252;Inherit;False;Property;_BorderSpeed;BorderSpeed;23;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-3212.715,-2402.252;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;304;-3419.813,-2152.184;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;305;-3048.813,-2276.184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;-1802.095,-1562.927;Inherit;False;Property;_FILL;FILL;28;0;Create;True;0;0;False;0;False;0.5805688;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;235;-1346.096,-1532.989;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;301;-2766.931,-2205.578;Inherit;False;0;2;2;0,0,0,0;0,0,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.Vector4Node;134;-1798.007,-1728.825;Inherit;False;Property;_RadialStrenthCenter;RadialStrenthCenter;11;0;Create;True;0;0;False;0;False;0,0,1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;290;-2767.937,-2134.573;Inherit;False;0;2;2;1,1,1,0;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.DynamicAppendNode;296;-2965.516,-2445.541;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;315;-1881.093,-2503.633;Inherit;False;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.DynamicAppendNode;135;-1220.471,-1571.667;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;289;-2736.247,-2039.393;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;300;-2507.523,-2257.506;Inherit;False;3;0;OBJECT;0;False;1;OBJECT;0;False;2;FLOAT;0;False;1;OBJECT;0
Node;AmplifyShaderEditor.VoronoiNode;321;-1892.799,-2747.066;Inherit;False;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;323;-1878.499,-2620.966;Inherit;False;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TimeNode;222;-4307.78,-1411.271;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;288;-2289.248,-2188.37;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;128;-1896.191,-1930.864;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;265;-4298.803,-1249.998;Inherit;False;Property;_UV_Speed;UV_Speed;14;0;Create;True;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;136;-1245.171,-1673.067;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;322;-1658.799,-2594.966;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;320;-1424.8,-2414.266;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;132;-1616.595,-2196.729;Inherit;True;Radial Shear;-1;;10;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-4054.451,-1363.749;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;324;-994.261,-2278.661;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-3848.525,-1215.36;Inherit;False;Property;_VoroSpeed;VoroSpeed;15;0;Create;True;0;0;False;0;False;1.85;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;264;-4180.84,-1744.321;Inherit;False;Property;_VoroTiling;VoroTiling;21;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinTimeNode;147;-3834.856,-1120.352;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;223;-3700.484,-1398.915;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TimeNode;346;-1031.318,-3110.943;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;155;-4161.639,-1521.226;Inherit;False;Property;_voroScale;voroScale;16;0;Create;True;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-3683.758,-1189.252;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;152;-3529.679,-1678.519;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,8.24;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-3034.813,-2091.184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;160;-1022.215,-1873.515;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;154;-3303.006,-1471.74;Inherit;False;0;1;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1.15;False;2;FLOAT;0.1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;-809.8197,-2925.652;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;75.74757,-1635.141;Inherit;False;Property;_VoroStrength;VoroStrength;30;0;Create;True;0;0;False;0;False;10;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-3117.493,-1687.045;Inherit;False;Property;_ribbonPower;ribbonPower;12;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;248;-376.6947,-1798.859;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;112;-2762.833,-2473.525;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1.19;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector2Node;146;-2813.214,-1319.863;Inherit;False;Property;_radial;radial;13;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;367;-1187.862,-3614.828;Inherit;False;Constant;_Vector0;Vector 0;27;0;Create;True;0;0;False;0;False;0.5,0.5;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;361;-1173.692,-3479.203;Inherit;False;Property;_RADIAL_STRENGTH;RADIAL_STRENGTH;27;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;253;-46.501,-1290.923;Inherit;False;Property;_SmoothStep;SmoothStep;29;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;214;-2556.099,-1313.905;Inherit;True;Radial Shear;-1;;14;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;349;-695.0688,-3070.399;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;181;-912.739,-3517.036;Inherit;True;Radial Shear;-1;;16;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-2896.933,-1636.409;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;252;204.1457,-1482.875;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;341.4495,-1713.139;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;254;47.31981,-2087.443;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;257;463.8971,-1416.022;Inherit;False;Property;_ColorPrincipal;Color Principal;8;0;Create;True;0;0;False;0;False;0.5773503,0.5773503,0.5773503,1;0,0.9879195,0.1549678,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;125;-2740.663,-1925.048;Inherit;False;0;3;2;0,0,0,0.3499962;1,1,1,0.5000076;0,0,0,0.6500038;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.FunctionNode;144;-2633.944,-1634.675;Inherit;True;Radial Shear;-1;;15;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;233;-832.4768,-2306.711;Inherit;False;Property;_Color3;Color 3;9;1;[HDR];Create;True;0;0;False;0;False;0.5773503,0.5773503,0.5773503,1;0,0.9879195,0.1549678,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;351;-589.8197,-2949.652;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;299;486.4346,-1634.882;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;356;-387.3468,-2993.718;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;348.2748,-2228.754;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;124;-2338.195,-1812.01;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;739.4278,-1530.058;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;256;816.4998,-1854.213;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;187;-249.1956,-3117.196;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCGrayscale;159;-1914.122,-1312.957;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;138;809.1315,-1130.508;Inherit;False;Property;_Color2;Color 2;7;1;[HDR];Create;True;0;0;False;0;False;0,4.924578,0.7724828,1;0,4.924578,0.7724828,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;603.3729,-2826.963;Inherit;True;2;2;0;FLOAT;2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;1120.86,-1235.785;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;246;1063.842,-1849.016;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;262;1320.537,-1769.575;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;1309.452,-2728.636;Inherit;True;details;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;369;1793.169,-1377.705;Inherit;False;opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;343;1855.136,-2119.65;Inherit;False;Property;_Metalicness;Metalicness;26;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;331;1239.136,-2085.756;Inherit;True;Property;_MainTex;_MainTex;25;1;[HDR];Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;199;-306.0177,-1170.155;Inherit;True;Standard;TangentNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;2.4;False;2;FLOAT;-3.24;False;3;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;-1718.849,-3109.217;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;97;-9722.01,-640.4863;Inherit;False;Constant;_Vector3;Vector 3;2;0;Create;True;0;0;False;0;False;0.25,0.5;1.1,0.23;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FresnelNode;186;431.3825,-3119.605;Inherit;True;Standard;TangentNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.14;False;2;FLOAT;-0.1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;182;431.793,-3407.705;Inherit;True;Standard;TangentNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.5;False;2;FLOAT;-0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;60;-9664.154,-101.3703;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;205;-150.3759,-2702.863;Inherit;False;Property;_VoronoiDif;VoronoiDif;19;0;Create;True;0;0;False;0;False;0.01;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;167;-1445.26,-3083.796;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2;-7491.714,-385.9459;Inherit;False;SecondColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;3;-8697.527,-1600.474;Inherit;True;0;1;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0.3;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StepOpNode;104;-8113.462,-530.0153;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-1907.153,-2920.915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-8021.708,-275.8416;Inherit;False;Property;_Color0;Color 0;6;1;[HDR];Create;True;0;0;False;0;False;0,4.924578,0.7724828,1;0,4.924578,0.7724828,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;176;-67.11805,-3480.718;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-2788.94,-2891.044;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;-1027.435,-2179.739;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;95;-9374.912,-688.4062;Inherit;True;Radial Shear;-1;;17;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;1750.546,-1988.541;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-561.687,-3174.429;Inherit;False;Property;_VoronoiScale;VoronoiScale;17;0;Create;True;0;0;False;0;False;0.95;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;93;-9282.979,-97.0228;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;24;-10097.07,-616.2995;Inherit;True;0;1;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1.15;False;2;FLOAT;2;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector4Node;337;879.1748,-2384.589;Inherit;False;Constant;_Vector5;Vector 5;11;0;Create;True;0;0;False;0;False;1,1,1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;206;-2412.968,-2897.756;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-1.2;False;2;FLOAT;50;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-6914.581,-1162.025;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;340;1099.783,-2274.241;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-8226.162,-1607.392;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-8739.391,-339.856;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;-7764.269,-1770.273;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.68;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;338;1331.991,-2318.628;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;15;-8510.296,-1867.988;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;30;-9961.004,-113.0773;Inherit;False;0;3;2;0,0,0,0.2500038;1,1,1,0.5000076;0,0,0,0.7499962;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;1307.278,-3079.684;Inherit;False;Property;_DetailsStrength;DetailsStrength;24;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;177;149.2025,-3475.629;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.16;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;347;-586.4205,-3381.938;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;108;-7354.532,-1188.34;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;166;-2191.287,-3181.511;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;157;-3926.59,-1612.639;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-7251.344,-1003.484;Inherit;False;Property;_Color1;Color 1;5;1;[HDR];Create;True;0;0;False;0;False;0.9056604,0.9056604,0.9056604,1;0.9056604,0.9056604,0.9056604,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-962.0139,-2554.209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-8485.496,-1603.253;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;162;-2166.487,-2916.776;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;106;-8545.692,-356.7121;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.01;False;2;FLOAT;0.64;False;3;FLOAT;4.56;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;62.39842,-2789.616;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;110;-10703.75,-478.7874;Inherit;False;Property;_SCALE;SCALE;10;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;111;-9051.549,-746.9565;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-7799.638,-408.2242;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;189;138.3919,-3125.128;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.13;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;276;-2901.277,-1856.819;Inherit;False;0;3;2;1,1,1,0;0,0,0,0.5000076;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.FunctionNode;335;-599.34,-2584.067;Inherit;True;Radial Shear;-1;;18;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-8037.858,-1795.694;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-8204.007,-1870.067;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;757.4006,-3486.055;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;91;-8539.413,-770.1935;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.01;False;2;FLOAT;0.64;False;3;FLOAT;4.56;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;818.0901,-3253.854;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;2064.123,-1398.813;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;190;1302.333,-3308.154;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;119;-3152.14,-2825.445;Inherit;True;Standard;TangentNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.5;False;2;FLOAT;-0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1240.308,-2559.698;Inherit;False;Property;_ReflectPower;ReflectPower;20;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;114;-3057.332,-2952.377;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;192;-124.2007,-2833.262;Inherit;False;Property;_VoronoiStep;VoronoiStep;18;0;Create;True;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-2216.833,-1991.075;Inherit;False;Property;_BorderVoroScale;BorderVoroScale;22;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;109;-10405.23,-534.842;Inherit;False;3;0;FLOAT2;0.71,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;174;-277.385,-3474.197;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;6.45;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;342;2133.335,-2166.45;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;6;-10393.85,-731.5202;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;339;1118.884,-2391.941;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;184;1036.808,-3307.379;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.16;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;354;-604.3039,-2773.866;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;1568.278,-3292.684;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;98;-10750.58,-638.0167;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;16;-8701.576,-1868.983;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;348;-722.002,-3235.892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-8776.179,-747.6406;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;188;18.27136,-3213.417;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;96;-9717.389,-517.0623;Inherit;False;Constant;_Vector4;Vector 4;2;0;Create;True;0;0;False;0;False;1,15;1.1,0.23;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;63;-9965.384,-27.70975;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;164;-2382.567,-3182.506;Inherit;True;0;1;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0.35;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-1884.998,-3183.59;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2422.974,-1734.99;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;sh_OrbShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;0;0;False;0;0;False;-1;0;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;295;0;297;0
WireConnection;295;1;298;2
WireConnection;305;0;295;0
WireConnection;305;1;304;1
WireConnection;235;0;234;0
WireConnection;296;0;305;0
WireConnection;296;1;304;2
WireConnection;135;0;134;1
WireConnection;135;1;235;0
WireConnection;300;0;301;0
WireConnection;300;1;290;0
WireConnection;300;2;234;0
WireConnection;321;0;296;0
WireConnection;288;0;300;0
WireConnection;288;1;289;2
WireConnection;128;1;135;0
WireConnection;136;0;134;3
WireConnection;136;1;134;4
WireConnection;322;0;321;0
WireConnection;322;1;323;0
WireConnection;322;2;315;0
WireConnection;320;0;322;0
WireConnection;132;1;288;0
WireConnection;132;2;128;0
WireConnection;132;3;136;0
WireConnection;266;0;222;2
WireConnection;266;1;265;0
WireConnection;324;0;320;0
WireConnection;324;1;132;0
WireConnection;223;0;266;0
WireConnection;148;0;151;0
WireConnection;148;1;147;1
WireConnection;152;0;264;0
WireConnection;152;1;223;0
WireConnection;306;0;298;1
WireConnection;160;0;324;0
WireConnection;154;0;152;0
WireConnection;154;1;148;0
WireConnection;154;2;155;0
WireConnection;350;0;346;1
WireConnection;248;0;160;0
WireConnection;112;0;296;0
WireConnection;112;1;306;0
WireConnection;214;2;146;0
WireConnection;214;4;148;0
WireConnection;349;0;350;0
WireConnection;181;2;367;0
WireConnection;181;3;361;0
WireConnection;143;0;140;0
WireConnection;143;1;154;0
WireConnection;252;0;160;0
WireConnection;252;1;248;0
WireConnection;252;2;253;0
WireConnection;309;0;112;0
WireConnection;309;1;310;0
WireConnection;254;0;252;0
WireConnection;144;1;143;0
WireConnection;144;2;214;0
WireConnection;144;3;214;0
WireConnection;144;4;214;0
WireConnection;351;0;181;0
WireConnection;351;1;349;0
WireConnection;299;0;309;0
WireConnection;299;1;252;0
WireConnection;356;0;181;0
WireConnection;356;1;351;0
WireConnection;232;0;233;0
WireConnection;232;1;160;0
WireConnection;232;2;254;0
WireConnection;124;0;125;0
WireConnection;124;1;144;0
WireConnection;258;0;299;0
WireConnection;258;1;257;0
WireConnection;256;0;232;0
WireConnection;256;1;258;0
WireConnection;187;0;356;0
WireConnection;159;0;124;0
WireConnection;368;1;187;0
WireConnection;139;0;159;0
WireConnection;139;1;138;0
WireConnection;246;0;256;0
WireConnection;246;1;159;0
WireConnection;262;0;246;0
WireConnection;262;1;139;0
WireConnection;197;0;368;0
WireConnection;369;0;160;0
WireConnection;163;0;161;0
WireConnection;163;1;168;0
WireConnection;60;0;30;0
WireConnection;60;1;63;2
WireConnection;167;0;163;0
WireConnection;2;0;8;0
WireConnection;104;0;91;0
WireConnection;104;1;106;0
WireConnection;168;0;162;0
WireConnection;176;0;174;0
WireConnection;120;0;114;0
WireConnection;120;1;119;0
WireConnection;314;0;320;0
WireConnection;314;1;132;0
WireConnection;95;1;24;0
WireConnection;95;2;97;0
WireConnection;95;4;96;0
WireConnection;332;0;331;0
WireConnection;332;1;262;0
WireConnection;93;0;60;0
WireConnection;24;0;109;0
WireConnection;24;1;6;1
WireConnection;88;0;108;0
WireConnection;88;1;10;0
WireConnection;340;0;337;3
WireConnection;340;1;337;4
WireConnection;18;0;14;0
WireConnection;105;0;95;0
WireConnection;105;1;93;0
WireConnection;23;0;19;0
WireConnection;338;0;339;0
WireConnection;338;1;340;0
WireConnection;15;0;16;0
WireConnection;177;0;176;0
WireConnection;177;1;193;0
WireConnection;108;0;23;0
WireConnection;108;1;104;0
WireConnection;166;0;164;0
WireConnection;195;0;167;0
WireConnection;195;1;196;0
WireConnection;14;0;3;0
WireConnection;162;0;206;0
WireConnection;106;0;105;0
WireConnection;193;0;192;0
WireConnection;193;1;205;0
WireConnection;111;0;95;0
WireConnection;8;0;104;0
WireConnection;8;1;4;0
WireConnection;189;0;188;0
WireConnection;189;1;192;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;17;0;15;0
WireConnection;183;0;177;0
WireConnection;183;1;182;0
WireConnection;91;0;99;0
WireConnection;185;0;189;0
WireConnection;185;1;186;0
WireConnection;371;0;197;0
WireConnection;371;1;369;0
WireConnection;190;0;184;0
WireConnection;109;0;98;0
WireConnection;109;1;110;0
WireConnection;174;0;181;0
WireConnection;174;2;191;0
WireConnection;342;0;197;0
WireConnection;342;1;343;0
WireConnection;339;0;337;1
WireConnection;339;1;337;2
WireConnection;184;0;183;0
WireConnection;184;1;185;0
WireConnection;201;0;190;0
WireConnection;201;1;202;0
WireConnection;348;0;346;2
WireConnection;99;0;111;0
WireConnection;99;1;93;0
WireConnection;188;0;187;0
WireConnection;161;0;166;0
WireConnection;0;0;332;0
WireConnection;0;2;139;0
WireConnection;0;3;342;0
WireConnection;0;9;371;0
ASEEND*/
//CHKSM=92A2739EC902B24129DAE3C8A8AB57F19F6F90BF
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_clouds"
{
	Properties
	{
		_Voro1AngleSpeed("Voro1AngleSpeed", Float) = 0.1
		_OffsetSpeed("OffsetSpeed", Float) = 0.1
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_VoroAdd0("VoroAdd0", Float) = 1
		_VoroScale("VoroScale", Float) = 0.5
		_NoiseScale("NoiseScale", Float) = 5
		_BSP("BSP", Vector) = (0,0.05,-1.8,0)
		[HDR]_ColorEm1("Color Em 1", Color) = (1,0,0,0)
		[HDR]_Color0("Color 0", Color) = (0,1,0,0)
		[HDR]_ColorEm3("Color Em 3", Color) = (0,0.1404357,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldNormal;
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _ColorEm1;
		uniform float _VoroAdd0;
		uniform float _Voro1AngleSpeed;
		uniform float _OffsetSpeed;
		uniform float _VoroScale;
		uniform float _NoiseScale;
		uniform float4 _Color0;
		uniform float4 _ColorEm3;
		uniform float3 _BSP;
		uniform float _EdgeLength;


		float2 voronoihash2( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2( n + g );
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


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		float2 voronoihash260( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi260( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash260( n + g );
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


		float2 voronoihash268( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi268( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash268( n + g );
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
			float temp_output_12_0 = ( _Voro1AngleSpeed * _Time.y );
			float time2 = temp_output_12_0;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float2 temp_cast_0 = (( _Time.y * ( _OffsetSpeed / 1000.0 ) )).xx;
			float2 panner142 = ( 1.0 * _Time.y * float2( 0,0 ) + temp_cast_0);
			float2 uv_TexCoord140 = i.uv_texcoord + panner142;
			float3 temp_output_143_0 = ( ase_vertexNormal + float3( uv_TexCoord140 ,  0.0 ) );
			float2 coords2 = temp_output_143_0.xy * _VoroAdd0;
			float2 id2 = 0;
			float2 uv2 = 0;
			float fade2 = 0.5;
			float voroi2 = 0;
			float rest2 = 0;
			for( int it2 = 0; it2 <8; it2++ ){
			voroi2 += fade2 * voronoi2( coords2, time2, id2, uv2, 0 );
			rest2 += fade2;
			coords2 *= 2;
			fade2 *= 0.5;
			}//Voronoi2
			voroi2 /= rest2;
			float2 temp_cast_3 = (( voroi2 * _VoroScale )).xx;
			float simpleNoise164 = SimpleNoise( temp_cast_3*_NoiseScale );
			float temp_output_261_0 = ( _VoroAdd0 + -0.1 );
			float time260 = temp_output_12_0;
			float2 coords260 = temp_output_143_0.xy * temp_output_261_0;
			float2 id260 = 0;
			float2 uv260 = 0;
			float fade260 = 0.5;
			float voroi260 = 0;
			float rest260 = 0;
			for( int it260 = 0; it260 <4; it260++ ){
			voroi260 += fade260 * voronoi260( coords260, time260, id260, uv260, 0 );
			rest260 += fade260;
			coords260 *= 2;
			fade260 *= 0.5;
			}//Voronoi260
			voroi260 /= rest260;
			float2 temp_cast_6 = (( _VoroScale * voroi260 )).xx;
			float simpleNoise152 = SimpleNoise( temp_cast_6*_NoiseScale );
			float temp_output_202_0 = ( simpleNoise164 - simpleNoise152 );
			float time268 = temp_output_12_0;
			float2 coords268 = temp_output_143_0.xy * ( temp_output_261_0 + 0.1 );
			float2 id268 = 0;
			float2 uv268 = 0;
			float fade268 = 0.5;
			float voroi268 = 0;
			float rest268 = 0;
			for( int it268 = 0; it268 <4; it268++ ){
			voroi268 += fade268 * voronoi268( coords268, time268, id268, uv268, 0 );
			rest268 += fade268;
			coords268 *= 2;
			fade268 *= 0.5;
			}//Voronoi268
			voroi268 /= rest268;
			float2 temp_cast_9 = (( _VoroScale * voroi268 )).xx;
			float simpleNoise270 = SimpleNoise( temp_cast_9*_NoiseScale );
			float temp_output_272_0 = ( temp_output_202_0 - ( simpleNoise164 - simpleNoise270 ) );
			o.Emission = ( ( _ColorEm1 * temp_output_202_0 ) + ( _Color0 * temp_output_272_0 ) + ( ( simpleNoise164 - temp_output_272_0 ) * _ColorEm3 ) ).rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV54 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode54 = ( _BSP.x + _BSP.y * pow( 1.0 - fresnelNdotV54, _BSP.z ) );
			o.Alpha = ( ( 1.0 - ( simpleNoise164 + simpleNoise152 + simpleNoise270 ) ) * fresnelNode54 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
-1906;29;1899;988;1352.006;611.0476;2.219869;True;True
Node;AmplifyShaderEditor.RangedFloatNode;146;-3226.945,625.0797;Inherit;False;Property;_OffsetSpeed;OffsetSpeed;1;0;Create;True;0;0;False;0;False;0.1;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;155;-3048.362,629.6812;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;145;-3246.631,455.33;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2917.358,527.9442;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;142;-2715.008,512.3112;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-1383.465,584.8713;Inherit;False;Constant;_VoroAdd1;VoroAdd1;9;0;Create;True;0;0;False;0;False;-0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1302.053,360.6009;Inherit;False;Property;_VoroAdd0;VoroAdd0;8;0;Create;True;0;0;False;0;False;1;11.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;133;-2712.52,299.0268;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;13;-2765.673,750.217;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-2564.934,645.3453;Inherit;False;Property;_Voro1AngleSpeed;Voro1AngleSpeed;0;0;Create;True;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;140;-2506.489,459.601;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;266;-1387.247,1043.495;Inherit;False;Constant;_VoroAdd2;VoroAdd2;9;0;Create;True;0;0;False;0;False;0.1;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;261;-1071.365,651.8307;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;267;-1075.147,1110.455;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2297.909,687.1342;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-2246.662,367.7492;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;265;-748.597,476.3761;Inherit;False;Property;_VoroScale;VoroScale;9;0;Create;True;0;0;False;0;False;0.5;2.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;260;-910.1423,584.7335;Inherit;True;0;0;1;0;4;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;2;-915.6111,217.6938;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;268;-913.924,1043.358;Inherit;True;0;0;1;0;4;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;162;-301.3859,928.1046;Inherit;False;Property;_NoiseScale;NoiseScale;10;0;Create;True;0;0;False;0;False;5;2.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-605.4686,170.1477;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;-600.5696,1097.297;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-522.9635,653.174;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;152;21.83039,680.9118;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;17.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;164;87.21243,15.01787;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;17.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;270;18.04928,1139.536;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;17.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;271;491.9813,539.7816;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;202;465.7552,104.3609;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;272;877.8452,537.6498;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;253;1669.696,792.943;Inherit;False;Property;_ColorEm3;Color Em 3;18;1;[HDR];Create;True;0;0;False;0;False;0,0.1404357,1,0;2.143547,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;55;2335.546,1846.864;Inherit;False;Property;_BSP;BSP;14;0;Create;True;0;0;False;0;False;0,0.05,-1.8;-1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;255;511.2826,-190.0803;Inherit;False;Property;_ColorEm1;Color Em 1;16;1;[HDR];Create;True;0;0;False;0;False;1,0,0,0;5.278032,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;275;851.828,898.6127;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;254;818.5956,286.1711;Inherit;False;Property;_Color0;Color 0;17;1;[HDR];Create;True;0;0;False;0;False;0,1,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;273;1236.929,843.4232;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;867.363,-107.4713;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;1218.033,500.1859;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;2109.938,955.8215;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;274;2183.311,1384.842;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;54;2734.233,1565.396;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.04;False;3;FLOAT;4.72;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;188;678.4186,1138.55;Inherit;False;Property;_StepEm1;StepEm1;13;0;Create;True;0;0;False;0;False;-0.04;0.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;2645.283,1195.918;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;278;2345.702,1656.639;Inherit;False;Property;_ViewDir;ViewDir;15;0;Create;True;0;0;False;0;False;0,0.05,-1.8;0.96,0,0.04;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;180;2617.403,322.4141;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;222;350.4333,1688.907;Inherit;False;Property;_StepEm3;StepEm3;12;0;Create;True;0;0;False;0;False;-0.17;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-2074.667,1088.67;Inherit;False;Property;_LateralSpeed;LateralSpeed;2;0;Create;True;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;277;-1848.465,1106.87;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;682.3701,1431.162;Inherit;False;Property;_StepEm2;StepEm2;11;0;Create;True;0;0;False;0;False;-0.08;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3452.893,164.4324;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;sh_clouds;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;3;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;155;0;146;0
WireConnection;144;0;145;2
WireConnection;144;1;155;0
WireConnection;142;0;144;0
WireConnection;140;1;142;0
WireConnection;261;0;4;0
WireConnection;261;1;262;0
WireConnection;267;0;261;0
WireConnection;267;1;266;0
WireConnection;12;0;3;0
WireConnection;12;1;13;2
WireConnection;143;0;133;0
WireConnection;143;1;140;0
WireConnection;260;0;143;0
WireConnection;260;1;12;0
WireConnection;260;2;261;0
WireConnection;2;0;143;0
WireConnection;2;1;12;0
WireConnection;2;2;4;0
WireConnection;268;0;143;0
WireConnection;268;1;12;0
WireConnection;268;2;267;0
WireConnection;263;0;2;0
WireConnection;263;1;265;0
WireConnection;269;0;265;0
WireConnection;269;1;268;0
WireConnection;264;0;265;0
WireConnection;264;1;260;0
WireConnection;152;0;264;0
WireConnection;152;1;162;0
WireConnection;164;0;263;0
WireConnection;164;1;162;0
WireConnection;270;0;269;0
WireConnection;270;1;162;0
WireConnection;271;0;164;0
WireConnection;271;1;270;0
WireConnection;202;0;164;0
WireConnection;202;1;152;0
WireConnection;272;0;202;0
WireConnection;272;1;271;0
WireConnection;275;0;164;0
WireConnection;275;1;152;0
WireConnection;275;2;270;0
WireConnection;273;0;164;0
WireConnection;273;1;272;0
WireConnection;258;0;255;0
WireConnection;258;1;202;0
WireConnection;256;0;254;0
WireConnection;256;1;272;0
WireConnection;257;0;273;0
WireConnection;257;1;253;0
WireConnection;274;0;275;0
WireConnection;54;1;55;1
WireConnection;54;2;55;2
WireConnection;54;3;55;3
WireConnection;191;0;274;0
WireConnection;191;1;54;0
WireConnection;180;0;258;0
WireConnection;180;1;256;0
WireConnection;180;2;257;0
WireConnection;277;0;276;0
WireConnection;0;2;180;0
WireConnection;0;9;191;0
ASEEND*/
//CHKSM=4EA57BAF19F4631BC751C380A014CDA72FBB3181
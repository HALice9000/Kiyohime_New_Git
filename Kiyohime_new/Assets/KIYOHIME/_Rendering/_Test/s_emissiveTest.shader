// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "s_emissiveTest"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Float0("Float 0", Float) = 0
		_voroAngle("voroAngle", Float) = 0.1
		_voroScale("voroScale", Float) = 0.1
		_step("step", Range( 0.25 , 1)) = 0.255
		_almostGreen("almostGreen", Range( 1 , 25.5)) = 1
		[HDR]_Color0("Color 0", Color) = (0,1,0,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform float _almostGreen;
		uniform float _Float0;
		uniform float _voroScale;
		uniform float _voroAngle;
		uniform float _step;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;


		float2 voronoihash33( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi33( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash33( n + g );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time33 = ( _Time.y * _voroAngle );
			float2 coords33 = i.uv_texcoord * _voroScale;
			float2 id33 = 0;
			float2 uv33 = 0;
			float voroi33 = voronoi33( coords33, time33, id33, uv33, 0 );
			o.Emission = ( ( _Color0 / _almostGreen ) + ( ( _Float0 * _Color0 ) * voroi33 ) ).rgb;
			float4 temp_cast_1 = (_step).xxxx;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 temp_cast_2 = (voroi33).xxxx;
			o.Alpha = ( step( temp_cast_1 , tex2D( _Albedo, uv_Albedo ) ) - temp_cast_2 ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
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
394;73;1078;635;575.521;-376.5551;1;False;False
Node;AmplifyShaderEditor.SimpleTimeNode;48;-360.6061,324.4744;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-340.5902,439.0452;Inherit;False;Property;_voroAngle;voroAngle;6;0;Create;True;0;0;False;0;False;0.1;-0.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-173.5358,523.2133;Inherit;False;Property;_voroScale;voroScale;7;0;Create;True;0;0;False;0;False;0.1;6.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;4.02993,13.50259;Inherit;False;Property;_Color0;Color 0;10;1;[HDR];Create;True;0;0;False;0;False;0,1,0,1;0.09803922,0.4588235,0.1313726,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-186.1916,381.1906;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;48.90145,-372.8358;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;290.2521,-354.6519;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;29.04148,565.6454;Inherit;False;Property;_step;step;8;0;Create;True;0;0;False;0;False;0.255;0.25;0.25;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;540.768,214.629;Inherit;False;Property;_almostGreen;almostGreen;9;0;Create;True;0;0;False;0;False;1;2.6;1;25.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-167.0898,711.9451;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;False;-1;e37adcf14e2bb8e4096e42860e690937;41844855321e9614fbd0b0aab2b2ac18;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;33;147.643,258.8102;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;3.84;False;2;FLOAT;0.6;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;60;692.474,-179.6064;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;63;291.7899,691.8981;Inherit;True;2;0;FLOAT;0.6666667;False;1;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;353.0695,-76.93318;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;11;-1410.9,-508.0976;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1152.005,184.1407;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;25;-426.2197,24.12239;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.06;False;2;FLOAT;0.39;False;3;FLOAT;1.79;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;661.6594,454.5993;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1132.525,-279.4052;Inherit;False;Property;_timeMult;timeMult;5;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-808.5674,-266.5821;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1405.366,113.3015;Inherit;False;Property;_NoiseTiling;NoiseTiling;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1361.506,524.5089;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-973.7875,-487.8866;Inherit;False;2;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;831.1433,-33.12489;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1592.515,584.8642;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-863.0504,163.8123;Inherit;True;Property;_wut;wut;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-512.6961,-371.3098;Inherit;False;Property;_EmissiveMin;EmissiveMin;1;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-279.0814,-176.5401;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;18;-1578.044,417.2445;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;7;-1674.555,-547.2485;Inherit;True;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;44;-1219.688,-765.1122;Inherit;True;0;3;2.82;0;1;False;10;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT;1;FLOAT2;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1020.741,170.6741;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;s_emissiveTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;48;0
WireConnection;47;1;45;0
WireConnection;51;0;50;0
WireConnection;51;1;6;0
WireConnection;33;1;47;0
WireConnection;33;2;46;0
WireConnection;60;0;6;0
WireConnection;60;1;56;0
WireConnection;63;0;64;0
WireConnection;63;1;2;0
WireConnection;49;0;51;0
WireConnection;49;1;33;0
WireConnection;11;0;7;4
WireConnection;20;0;27;0
WireConnection;20;1;24;0
WireConnection;25;4;19;0
WireConnection;54;0;63;0
WireConnection;54;1;33;0
WireConnection;9;0;41;0
WireConnection;9;1;8;0
WireConnection;24;0;18;0
WireConnection;24;1;23;0
WireConnection;41;0;44;0
WireConnection;59;0;60;0
WireConnection;59;1;49;0
WireConnection;19;1;20;0
WireConnection;10;0;3;0
WireConnection;10;1;9;0
WireConnection;44;0;11;0
WireConnection;0;2;59;0
WireConnection;0;9;54;0
ASEEND*/
//CHKSM=80F873644DD34942D29BE333755E4F7693B2A591
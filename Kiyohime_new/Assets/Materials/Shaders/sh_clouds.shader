// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_clouds"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		_Color1("Color1", Color) = (0.2924528,0.04552332,0.04552332,0)
		_Color2("Color2", Color) = (0.9245283,0.2151077,0,0)
		_CloudSpeed2("CloudSpeed2", Vector) = (-0.2,0.02,0,0)
		_CloudSpeed1("CloudSpeed1", Vector) = (-0.2,0.02,0,0)
		_NoiseScale1("NoiseScale1", Vector) = (0,0,0,0)
		_NoiseScale2("NoiseScale2", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color1;
		uniform float2 _NoiseScale1;
		uniform float2 _CloudSpeed1;
		uniform float2 _NoiseScale2;
		uniform float2 _CloudSpeed2;
		uniform float4 _Color2;
		uniform float _EdgeLength;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float2 voronoihash303( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi303( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash303( n + g );
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

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_output_293_0 = ( ( i.uv_texcoord * _NoiseScale1 ) + ( _Time.y * _CloudSpeed1 ) );
			float simplePerlin2D284 = snoise( temp_output_293_0 );
			simplePerlin2D284 = simplePerlin2D284*0.5 + 0.5;
			float simplePerlin2D297 = snoise( ( ( i.uv_texcoord * _NoiseScale2 ) + ( _Time.y * _CloudSpeed2 ) ) );
			simplePerlin2D297 = simplePerlin2D297*0.5 + 0.5;
			float time303 = 0.0;
			float2 coords303 = temp_output_293_0 * 1.0;
			float2 id303 = 0;
			float2 uv303 = 0;
			float fade303 = 0.5;
			float voroi303 = 0;
			float rest303 = 0;
			for( int it303 = 0; it303 <3; it303++ ){
			voroi303 += fade303 * voronoi303( coords303, time303, id303, uv303, 0 );
			rest303 += fade303;
			coords303 *= 2;
			fade303 *= 0.5;
			}//Voronoi303
			voroi303 /= rest303;
			float temp_output_304_0 = ( 1.0 - voroi303 );
			float lerpResult311 = lerp( -0.5 , 1.0 , ( simplePerlin2D284 * temp_output_304_0 ));
			float lerpResult320 = lerp( -2.0 , 0.7 , pow( ( 1.0 - length( ( ( ( i.uv_texcoord + float2( 0.2,0 ) ) * float2( 2,2 ) ) + float2( -1,-1 ) ) ) ) , 0.5 ));
			o.Emission = ( ( _Color1 * ( simplePerlin2D284 + simplePerlin2D297 + temp_output_304_0 ) ) + ( saturate( lerpResult311 ) * saturate( lerpResult320 ) * _Color2 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
385;73;1163;575;-300.8101;-2668.99;1.450227;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;305;1293.971,3553.42;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;309;1647.881,3554.324;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.2,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;296;1426.219,3006.661;Inherit;False;Property;_CloudSpeed1;CloudSpeed1;19;0;Create;True;0;0;False;0;False;-0.2,0.02;0.47,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;322;1128.967,2975.247;Inherit;False;Property;_NoiseScale1;NoiseScale1;20;0;Create;True;0;0;False;0;False;0,0;32.4,5.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;295;1430.224,2935.564;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;1638.019,2935.565;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0.4,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;1628.825,2813.149;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.4,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;1862.522,3553.839;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;293;1859.667,2810.888;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;306;2035.214,3543.373;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-1,-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;301;1459.752,3270.41;Inherit;False;Property;_CloudSpeed2;CloudSpeed2;18;0;Create;True;0;0;False;0;False;-0.2,0.02;0.36,0.002;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;323;1125.197,3123.886;Inherit;False;Property;_NoiseScale2;NoiseScale2;21;0;Create;True;0;0;False;0;False;0,0;32.17,6.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LengthOpNode;308;2159.713,3552.431;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;303;2095.62,3298.028;Inherit;False;0;0;1;0;3;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.OneMinusNode;310;2291.825,3550.191;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;304;2285.255,3314.281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;1669.615,3152.824;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.3,0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;1661.377,3273.114;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0.4,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;284;2060.73,2804.567;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;319;2485.24,3545.354;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;2416.691,3159.043;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;299;1844.283,3137.994;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;320;2659.273,3504.724;Inherit;False;3;0;FLOAT;-2;False;1;FLOAT;0.7;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;297;2049.267,3009.097;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;311;2586.152,3129.507;Inherit;False;3;0;FLOAT;-0.5;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;283;1990.254,2536.141;Inherit;False;Property;_Color1;Color1;16;0;Create;True;0;0;False;0;False;0.2924528,0.04552332,0.04552332,0;0.2924527,0.04552326,0.04552326,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;314;2767.369,3159.671;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;302;2375.862,2910.719;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;321;2834.408,3288.528;Inherit;False;Property;_Color2;Color2;17;0;Create;True;0;0;False;0;False;0.9245283,0.2151077,0,0;0.9245283,0.2151076,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;318;2835.164,3518.488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;312;3176.791,3239.684;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;2634.549,2630.896;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;254;818.5956,286.1711;Inherit;False;Property;_Color0;Color 0;23;1;[HDR];Create;True;0;0;False;0;False;0,1,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2324.67,610.6449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1410.63,450.7404;Inherit;False;Property;_VoroAdd0;VoroAdd0;8;0;Create;True;0;0;False;0;False;1;11.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;267;-1020.939,904.3677;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;54;2186.23,1625.003;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.04;False;3;FLOAT;4.72;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;274;2183.311,1384.842;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-466.2914,166.8046;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-1653.974,450.4499;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;142;-2122.32,595.0119;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;140;-1913.801,542.3017;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;146;-2634.257,707.7804;Inherit;False;Property;_OffsetSpeed;OffsetSpeed;1;0;Create;True;0;0;False;0;False;0.1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1972.246,728.046;Inherit;False;Property;_Voro1AngleSpeed;Voro1AngleSpeed;0;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;253;1669.696,792.943;Inherit;False;Property;_ColorEm3;Color Em 3;24;1;[HDR];Create;True;0;0;False;0;False;0,0.1404357,1,0;2.143547,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;1218.033,500.1859;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;2109.938,955.8215;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;271;518.4156,546.5999;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;270;30.8202,938.3942;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;17.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-207.8472,719.0573;Inherit;False;Property;_NoiseScale;NoiseScale;10;0;Create;True;0;0;False;0;False;5;2.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-2074.667,1088.67;Inherit;False;Property;_LateralSpeed;LateralSpeed;2;0;Create;True;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;261;-1147.163,547.3505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;682.3701,1431.162;Inherit;False;Property;_StepEm2;StepEm2;11;0;Create;True;0;0;False;0;False;-0.08;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;867.363,-107.4713;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;255;511.2826,-190.0803;Inherit;False;Property;_ColorEm1;Color Em 1;22;1;[HDR];Create;True;0;0;False;0;False;1,0,0,0;5.278032,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;13;-2172.985,832.9177;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;133;-2119.832,381.7275;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;273;1236.929,843.4232;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;268;-859.7161,837.2709;Inherit;True;0;0;1;0;4;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleAddOpNode;313;3220.286,2779.562;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;155;-2455.674,712.3819;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;188;678.4186,1138.55;Inherit;False;Property;_StepEm1;StepEm1;13;0;Create;True;0;0;False;0;False;-0.04;0.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;164;6.853462,421.1584;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;17.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;2;-915.6111,217.6938;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;266;-1333.039,837.4079;Inherit;False;Constant;_VoroAdd2;VoroAdd2;9;0;Create;True;0;0;False;0;False;0.1;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1705.221,769.8349;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;260;-926.5313,494.5939;Inherit;True;0;0;1;0;4;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-492.5424,453.2633;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;222;350.4333,1688.907;Inherit;False;Property;_StepEm3;StepEm3;12;0;Create;True;0;0;False;0;False;-0.17;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;-500.3718,697.0297;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;145;-2653.943,538.0306;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;277;-1848.465,1106.87;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-263.5676,333.5915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;265;-760.1861,463.3384;Inherit;False;Property;_VoroScale;VoroScale;9;0;Create;True;0;0;False;0;False;0.5;2.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;2645.283,1195.918;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-1406,554.1418;Inherit;False;Constant;_VoroAdd1;VoroAdd1;9;0;Create;True;0;0;False;0;False;-0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;202;496.6749,295.5012;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;275;851.828,898.6127;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;55;1787.544,1906.471;Inherit;False;Property;_BSP;BSP;14;0;Create;True;0;0;False;0;False;0,0.05,-1.8;-1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;278;1797.7,1716.246;Inherit;False;Property;_ViewDir;ViewDir;15;0;Create;True;0;0;False;0;False;0,0.05,-1.8;0.96,0,0.04;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;152;21.83039,680.9118;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;17.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;2617.403,322.4141;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;282;2936.435,313.4221;Inherit;False;Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;281;2994.908,1185.867;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;279;-166.7902,192.1319;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;272;877.8452,537.6498;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3566.601,2672.759;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;sh_clouds;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;3;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;309;0;305;0
WireConnection;294;0;295;0
WireConnection;294;1;296;0
WireConnection;288;0;305;0
WireConnection;288;1;322;0
WireConnection;307;0;309;0
WireConnection;293;0;288;0
WireConnection;293;1;294;0
WireConnection;306;0;307;0
WireConnection;308;0;306;0
WireConnection;303;0;293;0
WireConnection;310;0;308;0
WireConnection;304;0;303;0
WireConnection;298;0;305;0
WireConnection;298;1;323;0
WireConnection;300;0;295;0
WireConnection;300;1;301;0
WireConnection;284;0;293;0
WireConnection;319;0;310;0
WireConnection;316;0;284;0
WireConnection;316;1;304;0
WireConnection;299;0;298;0
WireConnection;299;1;300;0
WireConnection;320;2;319;0
WireConnection;297;0;299;0
WireConnection;311;2;316;0
WireConnection;314;0;311;0
WireConnection;302;0;284;0
WireConnection;302;1;297;0
WireConnection;302;2;304;0
WireConnection;318;0;320;0
WireConnection;312;0;314;0
WireConnection;312;1;318;0
WireConnection;312;2;321;0
WireConnection;287;0;283;0
WireConnection;287;1;302;0
WireConnection;144;0;145;2
WireConnection;144;1;155;0
WireConnection;267;0;261;0
WireConnection;267;1;266;0
WireConnection;54;1;55;1
WireConnection;54;2;55;2
WireConnection;54;3;55;3
WireConnection;274;0;275;0
WireConnection;263;0;2;0
WireConnection;143;0;133;0
WireConnection;143;1;140;0
WireConnection;142;0;144;0
WireConnection;140;1;142;0
WireConnection;256;0;254;0
WireConnection;256;1;272;0
WireConnection;257;0;273;0
WireConnection;257;1;253;0
WireConnection;271;0;164;0
WireConnection;271;1;270;0
WireConnection;270;0;269;0
WireConnection;270;1;162;0
WireConnection;261;0;4;0
WireConnection;261;1;262;0
WireConnection;258;0;255;0
WireConnection;258;1;202;0
WireConnection;273;0;164;0
WireConnection;273;1;272;0
WireConnection;268;0;143;0
WireConnection;268;1;12;0
WireConnection;268;2;267;0
WireConnection;313;0;287;0
WireConnection;313;1;312;0
WireConnection;155;0;146;0
WireConnection;164;0;279;0
WireConnection;164;1;162;0
WireConnection;2;0;143;0
WireConnection;2;1;12;0
WireConnection;2;2;4;0
WireConnection;12;0;3;0
WireConnection;12;1;13;2
WireConnection;260;0;143;0
WireConnection;260;1;12;0
WireConnection;260;2;261;0
WireConnection;264;0;265;0
WireConnection;264;1;260;0
WireConnection;269;0;265;0
WireConnection;269;1;268;0
WireConnection;277;0;276;0
WireConnection;280;0;145;2
WireConnection;191;0;274;0
WireConnection;191;1;54;0
WireConnection;202;0;164;0
WireConnection;202;1;152;0
WireConnection;275;0;164;0
WireConnection;275;1;152;0
WireConnection;275;2;270;0
WireConnection;152;0;264;0
WireConnection;152;1;162;0
WireConnection;180;0;258;0
WireConnection;180;1;256;0
WireConnection;180;2;257;0
WireConnection;282;0;180;0
WireConnection;281;0;191;0
WireConnection;279;0;263;0
WireConnection;279;1;280;0
WireConnection;272;0;202;0
WireConnection;272;1;271;0
WireConnection;0;2;313;0
ASEEND*/
//CHKSM=64D329AE11D9D5368F5F6358033963CFF01A563D
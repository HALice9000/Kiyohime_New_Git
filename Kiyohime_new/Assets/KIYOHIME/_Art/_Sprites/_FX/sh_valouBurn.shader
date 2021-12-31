// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sh_valouBurn"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_voroscale("voroscale", Float) = 5
		_noisescale("noisescale", Float) = 1
		_BURN("BURN", Range( -0.5 , 1.5)) = 1
		_Border("Border", Float) = 0.1
		[HDR]_DissolveCol("DissolveCol", Color) = (0,0,0,0)
		[HDR]_DissolveCol2("DissolveCol2", Color) = (0,0,0,0)
		_SpeedAngle("SpeedAngle", Float) = 1
		_BurnMiddle("BurnMiddle", Range( 0 , 1)) = 2.82
		_TillingOffsetBurnPoint("TillingOffsetBurnPoint", Vector) = (1,0,-0.5,0)
		_ColorPower("ColorPower", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 5.0
		#pragma surface surf Standard alpha:fade keepalpha 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		SamplerState sampler_TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _TillingOffsetBurnPoint;
		uniform float _voroscale;
		uniform float _SpeedAngle;
		uniform float _noisescale;
		uniform float _BurnMiddle;
		uniform float _BURN;
		uniform float _Border;
		uniform float4 _DissolveCol;
		uniform float _ColorPower;
		uniform float4 _DissolveCol2;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			float2 appendResult64 = (float2(_TillingOffsetBurnPoint.x , _TillingOffsetBurnPoint.y));
			float2 appendResult65 = (float2(_TillingOffsetBurnPoint.z , _TillingOffsetBurnPoint.w));
			float2 uv_TexCoord53 = i.uv_texcoord * appendResult64 + appendResult65;
			float time2 = ( _SpeedAngle * _Time.x );
			float2 coords2 = i.uv_texcoord * _voroscale;
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
			float2 temp_cast_0 = (voroi2).xx;
			float simplePerlin2D5 = snoise( temp_cast_0*_noisescale );
			simplePerlin2D5 = simplePerlin2D5*0.5 + 0.5;
			float lerpResult62 = lerp( length( uv_TexCoord53 ) , simplePerlin2D5 , _BurnMiddle);
			float MyNoise14 = lerpResult62;
			float temp_output_17_0 = ( 1.0 - _BURN );
			float temp_output_12_0 = step( MyNoise14 , temp_output_17_0 );
			float temp_output_20_0 = ( tex2DNode1.a * temp_output_12_0 );
			float4 appendResult34 = (float4(tex2DNode1.r , tex2DNode1.g , tex2DNode1.b , temp_output_20_0));
			float4 TexColor29 = appendResult34;
			o.Albedo = TexColor29.xyz;
			float temp_output_13_0 = ( temp_output_17_0 + _Border );
			float temp_output_18_0 = step( MyNoise14 , temp_output_13_0 );
			float4 color26 = ( ( ( tex2DNode1.a * ( temp_output_18_0 - temp_output_12_0 ) ) * ( _DissolveCol * _ColorPower ) ) + ( ( tex2DNode1.a * ( step( MyNoise14 , ( temp_output_13_0 + _Border ) ) - temp_output_18_0 ) ) * ( _ColorPower * _DissolveCol2 ) ) );
			o.Emission = color26.rgb;
			float alpha27 = temp_output_20_0;
			o.Alpha = ( 1.0 - alpha27 );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
223;73;1419;597;-40.20111;-270.9086;1.6;True;False
Node;AmplifyShaderEditor.CommentaryNode;15;-1236.811,-1245.123;Inherit;False;2877.46;398.1971;;10;14;2;51;45;3;52;5;6;62;60;NOISE;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1186.786,-1160.927;Inherit;False;Property;_SpeedAngle;SpeedAngle;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;63;-1261.835,-1537.572;Inherit;False;Property;_TillingOffsetBurnPoint;TillingOffsetBurnPoint;9;0;Create;True;0;0;False;0;False;1,0,-0.5,0;1,1,-0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;45;-1199.32,-1019.68;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;65;-981.835,-1430.572;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-949.8893,-1176.938;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;64;-984.835,-1523.572;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-954.0515,-1039.03;Inherit;False;Property;_voroscale;voroscale;1;0;Create;True;0;0;False;0;False;5;2.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;2;-690.2374,-1186.618;Inherit;True;0;1;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-753.5358,-1517.235;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0;False;1;FLOAT2;-0.5,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-490.202,-1107.296;Inherit;False;Property;_noisescale;noisescale;2;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;151.544,-1026.539;Inherit;False;Property;_BurnMiddle;BurnMiddle;8;0;Create;True;0;0;False;0;False;2.82;0.215;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1831.601,414.1789;Inherit;False;Property;_BURN;BURN;3;0;Create;True;0;0;False;0;False;1;0.78;-0.5;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;54;-245.6712,-1527.876;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;5;-297.2008,-1192.296;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1427.862,421.9174;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;62;567.1083,-1149.23;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1765.013,923.0577;Inherit;False;Property;_Border;Border;4;0;Create;True;0;0;False;0;False;0.1;0.015;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1439.879,698.5975;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;987.1005,-1138.75;Inherit;True;MyNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1421.815,1202.25;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-1472.092,172.0566;Inherit;True;14;MyNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;18;-1009.474,690.3486;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;37;-1066.319,1204.876;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;12;-1020.438,298.108;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-486.2782,1371.444;Inherit;False;Property;_DissolveCol2;DissolveCol2;6;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1.498039,0.282353,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-479.8689,849.8052;Inherit;False;Property;_DissolveCol;DissolveCol;5;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1.498039,0.1176471,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-790.7851,1200.394;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1003.914,33.15924;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;None;66a629f370ce457409df27ada57133bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;68;-456.2784,1077.899;Inherit;False;Property;_ColorPower;ColorPower;10;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-727.735,694.5673;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-420.0604,678.3171;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-638.5316,1162.8;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-212.3353,975.4185;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-220.0189,1134.851;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-198.6883,1277.461;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-622.4704,306.364;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-29.21326,760.2339;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-282.3062,94.7944;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-22.92454,397.8282;Inherit;False;alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;44;1263.289,293.6685;Inherit;False;785.5411;692.2999;;5;30;28;31;35;0;CORE;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;241.7153,784.1682;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;1396.121,755.9684;Inherit;True;27;alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;507.99,774.0448;Inherit;True;color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-6.390466,86.79242;Inherit;True;TexColor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;35;1612.34,727.4879;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;1313.289,343.6685;Inherit;True;29;TexColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;1325.141,539.4153;Inherit;True;26;color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1793.83,486.5203;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;sh_valouBurn;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;65;0;63;3
WireConnection;65;1;63;4
WireConnection;52;0;51;0
WireConnection;52;1;45;1
WireConnection;64;0;63;1
WireConnection;64;1;63;2
WireConnection;2;1;52;0
WireConnection;2;2;3;0
WireConnection;53;0;64;0
WireConnection;53;1;65;0
WireConnection;54;0;53;0
WireConnection;5;0;2;0
WireConnection;5;1;6;0
WireConnection;17;0;11;0
WireConnection;62;0;54;0
WireConnection;62;1;5;0
WireConnection;62;2;60;0
WireConnection;13;0;17;0
WireConnection;13;1;19;0
WireConnection;14;0;62;0
WireConnection;36;0;13;0
WireConnection;36;1;19;0
WireConnection;18;0;16;0
WireConnection;18;1;13;0
WireConnection;37;0;16;0
WireConnection;37;1;36;0
WireConnection;12;0;16;0
WireConnection;12;1;17;0
WireConnection;43;0;37;0
WireConnection;43;1;18;0
WireConnection;22;0;18;0
WireConnection;22;1;12;0
WireConnection;21;0;1;4
WireConnection;21;1;22;0
WireConnection;40;0;1;4
WireConnection;40;1;43;0
WireConnection;66;0;33;0
WireConnection;66;1;68;0
WireConnection;67;0;68;0
WireConnection;67;1;39;0
WireConnection;41;0;40;0
WireConnection;41;1;67;0
WireConnection;20;0;1;4
WireConnection;20;1;12;0
WireConnection;32;0;21;0
WireConnection;32;1;66;0
WireConnection;34;0;1;1
WireConnection;34;1;1;2
WireConnection;34;2;1;3
WireConnection;34;3;20;0
WireConnection;27;0;20;0
WireConnection;42;0;32;0
WireConnection;42;1;41;0
WireConnection;26;0;42;0
WireConnection;29;0;34;0
WireConnection;35;0;31;0
WireConnection;0;0;30;0
WireConnection;0;2;28;0
WireConnection;0;9;35;0
ASEEND*/
//CHKSM=76BB298A6475102813854E202A9623B7AA622A09
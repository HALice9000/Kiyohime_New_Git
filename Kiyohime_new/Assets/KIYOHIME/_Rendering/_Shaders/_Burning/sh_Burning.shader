// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "s_burning"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Burn("_Burn", Range( 0 , 1.1)) = 0.1856532
		_Mask("Mask", 2D) = "white" {}
		_Distorsion_map("Distorsion_map", 2D) = "bump" {}
		_Distorsion_amount("Distorsion_amount", Range( 0 , 1)) = 0
		_scrol_speed("scrol_speed", Range( 0 , 1)) = 0
		[HDR]_warm("warm", Color) = (0,0,0,0)
		[HDR]_hot("hot", Color) = (0,0,0,0)
		_Float0("Float 0", Float) = 2
		[HDR]_Albedo("_Albedo", 2D) = "white" {}
		_heat_wave("_heat_wave", Range( 0 , 1)) = 0
		_wiggle_amount("_wiggle_amount", Float) = 0
		[HDR]_TextureColoration("TextureColoration", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _Distorsion_map;
		uniform float _scrol_speed;
		uniform sampler2D _Mask;
		uniform float _heat_wave;
		uniform float _Burn;
		uniform float _wiggle_amount;
		uniform float4 _TextureColoration;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _warm;
		uniform float4 _hot;
		uniform float4 _Distorsion_map_ST;
		uniform float _Distorsion_amount;
		uniform float _Float0;
		SamplerState sampler_Albedo;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_12_0 = ( _Time.y * _scrol_speed );
			float2 panner35 = ( temp_output_12_0 * float2( 0,-1 ) + v.texcoord.xy);
			float3 tex2DNode31 = UnpackNormal( tex2Dlod( _Distorsion_map, float4( panner35, 0, 0.0) ) );
			float4 tex2DNode21 = tex2Dlod( _Mask, float4( ( ( (tex2DNode31).xy * _heat_wave ) + v.texcoord.xy ), 0, 0.0) );
			float temp_output_22_0 = step( tex2DNode21.r , _Burn );
			float3 VertexOffset77 = ( ( ( ase_worldPos * ase_vertex3Pos ) * tex2DNode31 * temp_output_22_0 ) * _wiggle_amount );
			v.vertex.xyz += VertexOffset77;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode25 = tex2D( _Albedo, uv_Albedo );
			float2 uv_Distorsion_map = i.uv_texcoord * _Distorsion_map_ST.xy + _Distorsion_map_ST.zw;
			float temp_output_12_0 = ( _Time.y * _scrol_speed );
			float2 panner10 = ( temp_output_12_0 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord8 = i.uv_texcoord + panner10;
			float4 lerpResult16 = lerp( _warm , _hot , tex2D( _Mask, ( ( (UnpackNormal( tex2D( _Distorsion_map, uv_Distorsion_map ) )).xy * _Distorsion_amount ) + uv_TexCoord8 ) ).r);
			float4 temp_cast_0 = (_Float0).xxxx;
			float2 panner35 = ( temp_output_12_0 * float2( 0,-1 ) + i.uv_texcoord);
			float3 tex2DNode31 = UnpackNormal( tex2D( _Distorsion_map, panner35 ) );
			float4 tex2DNode21 = tex2D( _Mask, ( ( (tex2DNode31).xy * _heat_wave ) + i.uv_texcoord ) );
			float temp_output_22_0 = step( tex2DNode21.r , _Burn );
			float temp_output_27_0 = ( _Burn / 1.1 );
			float temp_output_44_0 = step( tex2DNode21.r , ( 1.0 - temp_output_27_0 ) );
			float temp_output_46_0 = ( temp_output_44_0 - step( tex2DNode21.r , ( 1.0 - _Burn ) ) );
			float4 temp_cast_1 = (temp_output_46_0).xxxx;
			float4 temp_cast_2 = (temp_output_46_0).xxxx;
			float4 Emission75 = ( ( ( ( pow( lerpResult16 , temp_cast_0 ) * _Float0 ) * ( temp_output_22_0 + ( temp_output_22_0 - step( tex2DNode21.r , temp_output_27_0 ) ) ) ) - temp_cast_1 ) - temp_cast_2 );
			o.Emission = ( ( _TextureColoration * ( 1.0 - step( tex2DNode25 , float4( 0,0,0,0 ) ) ) ) + Emission75 ).rgb;
			float Mask71 = temp_output_44_0;
			float TexAlpha73 = tex2DNode25.a;
			float temp_output_85_0 = ( Mask71 * TexAlpha73 );
			o.Alpha = temp_output_85_0;
			clip( temp_output_85_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
336;73;1188;611;-826.3502;458.9491;1.928259;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;11;-3396.433,284.9196;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3590.471,595.5016;Inherit;False;Property;_scrol_speed;scrol_speed;5;0;Create;True;0;0;False;0;False;0;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-3164.159,580.9972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3459.995,1199.978;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;35;-3146.687,1205.571;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2997.951,-241.7855;Inherit;True;Property;_Distorsion_map;Distorsion_map;3;0;Create;True;0;0;False;0;False;None;77fdad851e93f394c9f8a1b1a63b56f3;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;31;-2835.297,1217.581;Inherit;True;Property;_TextureSample4;Texture Sample 4;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-2714.306,-59.92687;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-2436.545,1427.256;Inherit;False;Property;_heat_wave;_heat_wave;10;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;37;-2438.336,1210.391;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;-2370.644,-47.44933;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3043.731,131.8085;Inherit;False;Property;_Distorsion_amount;Distorsion_amount;4;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;10;-2893.101,580.0892;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2052.647,1206.265;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2039.197,-4.955458;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-2040.229,1483.728;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2307.234,668.6743;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1329.042,1026.607;Inherit;False;Property;_Burn;_Burn;0;0;Create;True;0;0;False;0;False;0.1856532;0.617;0;1.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1783.264,1190.66;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1413.662,1412.521;Inherit;False;Constant;_divide_amount;_divide_amount;10;0;Create;True;0;0;False;0;False;1.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1589.367,-34.76249;Inherit;True;Property;_Mask;Mask;2;0;Create;True;0;0;False;0;False;None;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1548.547,431.062;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;14;-1107.1,-533.1076;Inherit;False;Property;_warm;warm;6;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1,0.5426355,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-1371,816.7325;Inherit;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-1108.188,-343.4617;Inherit;False;Property;_hot;hot;7;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1,0.9333204,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;27;-962.1638,1138.008;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1290.084,270.2845;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;16;-822.3092,-409.8065;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;26;-627.4496,896.4803;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;22;-780.3939,635.2603;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-698.6758,-24.87227;Inherit;False;Property;_Float0;Float 0;8;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;43;-638.6674,1298.612;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;18;-395.9681,-416.3783;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-373.6231,868.8303;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;42;-684.3202,1606.245;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-116.0658,625.3719;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;45;-283.0327,1712.335;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-106.4848,-479.3396;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;44;-294.9554,1338.959;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;200.1423,346.6003;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;46;12.07654,1423.329;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;54;378.4311,-103.4158;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;47;549.9808,691.1495;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;51;371.2061,102.8416;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;52;783.2705,832.8545;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;806.7667,-52.52385;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;25;649.5255,-488.3497;Inherit;True;Property;_Albedo;_Albedo;9;1;[HDR];Create;True;0;0;False;0;False;-1;None;1454cd2d0045b4d4b904035c6d43b3d6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;941.0759,508.897;Inherit;False;Property;_wiggle_amount;_wiggle_amount;11;0;Create;True;0;0;False;0;False;0;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;69;1171.529,-631.6949;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1027.406,203.169;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;833.9762,971.9586;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;70;1391.663,-631.6815;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;62;1679.913,-356.6552;Inherit;False;Property;_TextureColoration;TextureColoration;13;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;1061.921,964.9169;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1271.007,365.1852;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;1105.739,-373.4441;Inherit;False;TexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-69.97118,1225.6;Inherit;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;1488.159,469.3751;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;1713.802,198.4766;Inherit;False;75;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;1985.953,-220.2462;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;1863.57,475.1281;Inherit;False;73;TexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;1856.505,386.5712;Inherit;False;71;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;1981.952,147.924;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;2054.958,388.8575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;67;1641.074,312.9067;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;58;1416.168,-210.5047;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;59;1093.719,-239.0805;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;60;1090.591,12.47599;Inherit;False;Property;_LerpOpposite;LerpOpposite;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;1958.265,586.5531;Inherit;False;77;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;945.2996,-284.4181;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;76.13;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;84;2247.55,204.5631;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;s_burning;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;TransparentCutout;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;35;0;36;0
WireConnection;35;1;12;0
WireConnection;31;0;3;0
WireConnection;31;1;35;0
WireConnection;4;0;3;0
WireConnection;37;0;31;0
WireConnection;5;0;4;0
WireConnection;10;1;12;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;8;1;10;0
WireConnection;41;0;38;0
WireConnection;41;1;40;0
WireConnection;9;0;6;0
WireConnection;9;1;8;0
WireConnection;21;0;1;0
WireConnection;21;1;41;0
WireConnection;27;0;23;0
WireConnection;27;1;28;0
WireConnection;2;0;1;0
WireConnection;2;1;9;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;16;2;2;1
WireConnection;26;0;21;1
WireConnection;26;1;27;0
WireConnection;22;0;21;1
WireConnection;22;1;23;0
WireConnection;43;0;27;0
WireConnection;18;0;16;0
WireConnection;18;1;20;0
WireConnection;29;0;22;0
WireConnection;29;1;26;0
WireConnection;42;0;23;0
WireConnection;30;0;22;0
WireConnection;30;1;29;0
WireConnection;45;0;21;1
WireConnection;45;1;42;0
WireConnection;19;0;18;0
WireConnection;19;1;20;0
WireConnection;44;0;21;1
WireConnection;44;1;43;0
WireConnection;24;0;19;0
WireConnection;24;1;30;0
WireConnection;46;0;44;0
WireConnection;46;1;45;0
WireConnection;47;0;24;0
WireConnection;47;1;46;0
WireConnection;52;0;47;0
WireConnection;55;0;54;0
WireConnection;55;1;51;0
WireConnection;69;0;25;0
WireConnection;53;0;55;0
WireConnection;53;1;31;0
WireConnection;53;2;22;0
WireConnection;48;0;52;0
WireConnection;48;1;46;0
WireConnection;70;0;69;0
WireConnection;75;0;48;0
WireConnection;56;0;53;0
WireConnection;56;1;57;0
WireConnection;73;0;25;4
WireConnection;71;0;44;0
WireConnection;77;0;56;0
WireConnection;63;0;62;0
WireConnection;63;1;70;0
WireConnection;64;0;63;0
WireConnection;64;1;76;0
WireConnection;85;0;72;0
WireConnection;85;1;74;0
WireConnection;58;0;25;0
WireConnection;58;1;59;0
WireConnection;58;2;60;0
WireConnection;59;0;25;0
WireConnection;65;0;25;1
WireConnection;65;1;25;2
WireConnection;65;2;25;3
WireConnection;84;2;64;0
WireConnection;84;9;85;0
WireConnection;84;10;85;0
WireConnection;84;11;78;0
ASEEND*/
//CHKSM=66675A23F8E502E0C156438426F63263A9011D42
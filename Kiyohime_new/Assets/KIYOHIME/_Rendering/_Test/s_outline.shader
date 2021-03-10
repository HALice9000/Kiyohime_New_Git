// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "s_outline"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_thickness("thickness", Range( 0 , 0.99)) = 0.99
		_force("force", Float) = 0
		_Color0("Color 0", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 4.6
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_TextureSample0);
		uniform float4 _TextureSample0_ST;
		SamplerState sampler_TextureSample0;
		uniform float _thickness;
		uniform float4 _Color0;
		uniform float _force;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = SAMPLE_TEXTURE2D( _TextureSample0, sampler_TextureSample0, uv_TextureSample0 );
			float temp_output_44_0 = step( tex2DNode1.a , 0.0 );
			float4 temp_output_57_0 = ( tex2DNode1 + temp_output_44_0 );
			o.Albedo = temp_output_57_0.rgb;
			o.Emission = ( temp_output_57_0 + ( ( 1.0 - step( step( tex2DNode1.a , _thickness ) , temp_output_44_0 ) ) * _Color0 * _force ) ).rgb;
			o.Alpha = ( 1.0 - temp_output_57_0 ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
-1920;2;1920;1019;1126.955;715.7566;1.3;True;True
Node;AmplifyShaderEditor.SamplerNode;1;-2296.047,-225.6849;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;dc9ca09503d3c894aa7c3ef9714cdfb1;8e4ae1e8f342fad4bbc80d191636fb43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-2392.663,142.8577;Inherit;False;Property;_thickness;thickness;1;0;Create;True;0;0;False;0;False;0.99;0.99;0;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;44;-1916.812,-447.8223;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;4;-1981.648,-103.1594;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;45;-1681.579,-446.0461;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1591.076,-120.4187;Inherit;False;Property;_force;force;3;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-744.1718,280.7403;Inherit;False;Property;_Color0;Color 0;4;0;Create;True;0;0;False;0;False;1,1,1,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;51;-730.7978,-218.3289;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-364.7511,-379.3698;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-441.4583,99.67135;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;58;-191.9144,-95.09314;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;68.0011,-398.4365;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;16;412.3856,-109.3746;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;s_outline;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0;True;False;0;True;TransparentCutout;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexScale;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;44;0;1;4
WireConnection;4;0;1;4
WireConnection;4;1;7;0
WireConnection;45;0;4;0
WireConnection;45;1;44;0
WireConnection;51;0;45;0
WireConnection;57;0;1;0
WireConnection;57;1;44;0
WireConnection;9;0;51;0
WireConnection;9;1;10;0
WireConnection;9;2;52;0
WireConnection;58;0;57;0
WireConnection;60;0;57;0
WireConnection;60;1;9;0
WireConnection;16;0;57;0
WireConnection;16;2;60;0
WireConnection;16;9;58;0
ASEEND*/
//CHKSM=8EAB96C41E042CFC13C587B89C0414EDBED661D6
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KiyohimeShaders/SH_CloudMonster"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (0,0.5719719,1,1)
		[HDR]_Color1("Color 1", Color) = (0,1,0.6669481,1)
		_VoroBorderScale("VoroBorderScale", Float) = 1
		_StepOutter("StepOutter", Float) = 2.5
		_StepInner("StepInner", Vector) = (0,1,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureStrength("TextureStrength", Float) = 0
		_TextureTiling("TextureTiling", Vector) = (1,1,0,0)
		_TextureSat("TextureSat", Float) = 0.1
		_StarsSpeedRatio("StarsSpeedRatio", Float) = 0.1
		_WorldImpactance("WorldImpactance", Float) = 0
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 5.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow exclude_path:deferred 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 uv_tex3coord;
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform float _VoroBorderScale;
		uniform float _WorldImpactance;
		uniform float _StepOutter;
		uniform float2 _StepInner;
		uniform float4 _Color1;
		uniform sampler2D _TextureSample0;
		uniform float2 _TextureTiling;
		uniform float _StarsSpeedRatio;
		uniform float _TextureStrength;
		uniform float _TextureSat;


		float2 voronoihash20( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi20( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash20( n + g );
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float time20 = 0.0;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult143 = (float2(ase_worldPos.x , ( ase_worldPos.y + ase_worldPos.z )));
			float3 uvs3_TexCoord98 = i.uv_tex3coord;
			uvs3_TexCoord98.xy = i.uv_tex3coord.xy + ( appendResult143 * _WorldImpactance );
			float3 uvs3_TexCoord72 = i.uv_tex3coord;
			uvs3_TexCoord72.xy = i.uv_tex3coord.xy + uvs3_TexCoord98.xy;
			float3 MoveUV116 = uvs3_TexCoord72;
			float2 coords20 = MoveUV116.xy * _VoroBorderScale;
			float2 id20 = 0;
			float2 uv20 = 0;
			float fade20 = 0.5;
			float voroi20 = 0;
			float rest20 = 0;
			for( int it20 = 0; it20 <8; it20++ ){
			voroi20 += fade20 * voronoi20( coords20, time20, id20, uv20, 0 );
			rest20 += fade20;
			coords20 *= 2;
			fade20 *= 0.5;
			}//Voronoi20
			voroi20 /= rest20;
			float RoundZone17 = ( 1.0 - length( ( i.uv_texcoord + float2( -0.5,-0.5 ) ) ) );
			float smoothstepResult62 = smoothstep( 0.5 , 1.0 , RoundZone17);
			float smoothstepResult70 = smoothstep( voroi20 , ( voroi20 * _StepOutter ) , smoothstepResult62);
			float smoothstepResult83 = smoothstep( ( smoothstepResult70 * _StepInner.x ) , _StepInner.y , smoothstepResult70);
			float NoisedRound26 = ( smoothstepResult70 + smoothstepResult83 );
			float2 appendResult156 = (float2(ase_worldPos.x , ( ase_worldPos.y + ase_worldPos.z )));
			float2 uv_TexCoord145 = i.uv_texcoord * _TextureTiling + ( appendResult156 / _StarsSpeedRatio );
			float grayscale148 = Luminance(tex2D( _TextureSample0, uv_TexCoord145 ).rgb);
			float Texture147 = ( ( grayscale148 * _TextureStrength ) + _TextureSat );
			o.Emission = ( ( _Color0 * i.vertexColor * NoisedRound26 ) + ( ( i.vertexColor * _Color1 * NoisedRound26 ) * Texture147 ) ).rgb;
			o.Alpha = ( NoisedRound26 * i.vertexColor.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
338;73;1199;538;2202.187;1511.603;2.487719;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;71;-5398.517,-2328.954;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;142;-5167.699,-2235.944;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;16;-7418.688,-2011.565;Inherit;False;1012.65;378.5044;Comment;6;12;17;13;10;11;5;RoundZone;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-5192.765,-2027.335;Inherit;False;Property;_WorldImpactance;WorldImpactance;10;0;Create;True;0;0;False;0;False;0;1.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;143;-5000.699,-2305.944;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;12;-7364.616,-1818.98;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;False;-0.5,-0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-4941.565,-2110.535;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-7368.688,-1961.565;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;98;-4791.438,-2293.038;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-7126.191,-1875.392;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;10;-6989.522,-1874.452;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-4312.828,-2340.588;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;151;-7754.324,-1094.72;Inherit;False;1991.562;503.7913;Comment;14;150;147;149;148;144;145;146;156;155;154;157;158;159;160;Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;13;-6809.107,-1875.657;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-4064.046,-2347.518;Inherit;False;MoveUV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;139;-5655.202,-1239.259;Inherit;False;2700.028;661.0336;Comment;13;117;53;24;20;76;86;70;83;18;62;79;85;26;PATERN in;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;154;-7705.332,-826.9158;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-6639.804,-1879.859;Inherit;True;RoundZone;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;155;-7474.514,-733.9058;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-5352.089,-981.546;Inherit;False;116;MoveUV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-5154.208,-701.7579;Inherit;False;Property;_VoroBorderScale;VoroBorderScale;2;0;Create;True;0;0;False;0;False;1;-0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;156;-7307.514,-803.9058;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-7304.347,-694.0508;Inherit;False;Property;_StarsSpeedRatio;StarsSpeedRatio;9;0;Create;True;0;0;False;0;False;0.1;5.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-4887.526,-768.9549;Inherit;False;Property;_StepOutter;StepOutter;3;0;Create;True;0;0;False;0;False;2.5;1.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;20;-5143.796,-973.7451;Inherit;True;0;0;1;0;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GetLocalVarNode;18;-4921.75,-1189.259;Inherit;True;17;RoundZone;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-4689.723,-831.225;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-4646.48,-1182.904;Inherit;True;3;0;FLOAT;0.32;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;159;-7090.347,-797.0508;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;146;-7704.324,-997.9067;Inherit;False;Property;_TextureTiling;TextureTiling;7;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;86;-4246.025,-763.3585;Inherit;False;Property;_StepInner;StepInner;4;0;Create;True;0;0;False;0;False;0,1;0.98,1.08;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;70;-4290.765,-1001.094;Inherit;True;3;0;FLOAT;0.32;False;1;FLOAT;-0.17;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;145;-7483.324,-1015.907;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;144;-7226.324,-1043.646;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;False;-1;None;430d748bd8d700048b209345a09f8710;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-4016.729,-846.0643;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-6777.461,-796.6021;Inherit;False;Property;_TextureStrength;TextureStrength;6;0;Create;True;0;0;False;0;False;0;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;83;-3783.285,-867.3534;Inherit;True;3;0;FLOAT;0.32;False;1;FLOAT;-0.17;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;148;-6790.218,-1044.507;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-6480.605,-801.7933;Inherit;False;Property;_TextureSat;TextureSat;8;0;Create;True;0;0;False;0;False;0.1;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-6529.104,-1039.544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-3433.747,-998.8834;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;-6264.92,-1041.699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-3198.173,-1004.026;Inherit;True;NoisedRound;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;141;-2333.081,-1272.48;Inherit;False;1523.412;910.0004;Comment;9;152;126;125;3;2;123;153;191;193;COLORS;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;-1995.665,-798.4248;Inherit;False;26;NoisedRound;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-6020.413,-1047.015;Inherit;True;Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;123;-2094.015,-576.6702;Inherit;False;Property;_Color1;Color 1;1;1;[HDR];Create;True;0;0;False;0;False;0,1,0.6669481,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;191;-1937.039,-1097.493;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-1654.882,-776.1867;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-2168.067,-1222.48;Inherit;False;Property;_Color0;Color 0;0;1;[HDR];Create;True;0;0;False;0;False;0,0.5719719,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;153;-1630.432,-535.6262;Inherit;False;147;Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1342.896,-657.2401;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1651.027,-1132.743;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;37;-736.7057,-723.0687;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-4556.819,-2185.414;Inherit;False;WorldUV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;-1032.683,-925.0388;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;140;-25.19516,-1010.178;Inherit;False;313;482;Comment;1;0;CORE;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-401.0782,-802.6033;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;24.80494,-960.1774;Float;False;True;-1;7;ASEMaterialInspector;0;0;Unlit;KiyohimeShaders/SH_CloudMonster;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.98;True;False;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;4;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;142;0;71;2
WireConnection;142;1;71;3
WireConnection;143;0;71;1
WireConnection;143;1;142;0
WireConnection;188;0;143;0
WireConnection;188;1;189;0
WireConnection;98;1;188;0
WireConnection;11;0;5;0
WireConnection;11;1;12;0
WireConnection;10;0;11;0
WireConnection;72;1;98;0
WireConnection;13;0;10;0
WireConnection;116;0;72;0
WireConnection;17;0;13;0
WireConnection;155;0;154;2
WireConnection;155;1;154;3
WireConnection;156;0;154;1
WireConnection;156;1;155;0
WireConnection;20;0;117;0
WireConnection;20;2;53;0
WireConnection;76;0;20;0
WireConnection;76;1;24;0
WireConnection;62;0;18;0
WireConnection;159;0;156;0
WireConnection;159;1;160;0
WireConnection;70;0;62;0
WireConnection;70;1;20;0
WireConnection;70;2;76;0
WireConnection;145;0;146;0
WireConnection;145;1;159;0
WireConnection;144;1;145;0
WireConnection;79;0;70;0
WireConnection;79;1;86;1
WireConnection;83;0;70;0
WireConnection;83;1;79;0
WireConnection;83;2;86;2
WireConnection;148;0;144;0
WireConnection;149;0;148;0
WireConnection;149;1;150;0
WireConnection;85;0;70;0
WireConnection;85;1;83;0
WireConnection;158;0;149;0
WireConnection;158;1;157;0
WireConnection;26;0;85;0
WireConnection;147;0;158;0
WireConnection;125;0;191;0
WireConnection;125;1;123;0
WireConnection;125;2;193;0
WireConnection;152;0;125;0
WireConnection;152;1;153;0
WireConnection;3;0;2;0
WireConnection;3;1;191;0
WireConnection;3;2;193;0
WireConnection;129;0;98;0
WireConnection;126;0;3;0
WireConnection;126;1;152;0
WireConnection;194;0;193;0
WireConnection;194;1;37;4
WireConnection;0;2;126;0
WireConnection;0;9;194;0
ASEEND*/
//CHKSM=11FBDC2CD6C13A74BED0839A74A2E9ACAC47ABD8
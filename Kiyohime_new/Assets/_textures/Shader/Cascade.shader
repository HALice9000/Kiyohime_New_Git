// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cascade"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_WaterBorder("WaterBorder", Color) = (0.5773503,0.5773503,0.5773503,1)
		_LittleWater("LittleWater", Color) = (0.5773503,0.5773503,0.5773503,1)
		_WaterFallColor("WaterFallColor", Color) = (0.5773503,0.5773503,0.5773503,1)
		_HighWavesVoronoi("HighWavesVoronoi", Float) = 3.63
		_BorderVoronoi("BorderVoronoi", Float) = 3.63
		_HighWavesForce("HighWavesForce", Float) = 2.86
		_BorderForce("BorderForce", Float) = 2.86
		_WaveOndulatingSpeed("WaveOndulatingSpeed", Float) = 2
		_WarterFallSpeed("WarterFallSpeed", Float) = 0.2
		_WarterFallSpeed2("WarterFallSpeed2", Float) = 0.2
		_WarterFallSpeed3("WarterFallSpeed3", Float) = 0.1
		_VoroScale("VoroScale", Float) = 5
		_TextureForce("TextureForce", Float) = 5.6
		_Steps("Steps", Vector) = (0.5,0.23,0,0)
		_StepsBorder("StepsBorder", Vector) = (0.5,0.18,0,0)
		_Fall2Tiling("Fall2Tiling", Vector) = (5,1,0,0)
		_FallBorder("FallBorder", Vector) = (10,1,0,0)
		_TextureScaling("TextureScaling", Vector) = (1,1,0,0)
		_HighWavesVoronoi2("HighWavesVoronoi2", Float) = 0.91
		_HighWavesForce2("HighWavesForce2", Float) = 2.86
		_Steps2("Steps2", Vector) = (0.5,0.23,0,0)
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
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _WaterFallColor;
		uniform sampler2D _TextureSample0;
		uniform float2 _TextureScaling;
		uniform float _WarterFallSpeed;
		uniform float _TextureForce;
		uniform float4 _LittleWater;
		uniform float _HighWavesVoronoi;
		uniform float2 _Fall2Tiling;
		uniform float _WarterFallSpeed2;
		uniform float2 _Steps;
		uniform float _HighWavesForce;
		uniform float _HighWavesVoronoi2;
		uniform float2 _Steps2;
		uniform float _HighWavesForce2;
		uniform float4 _WaterBorder;
		uniform float _BorderForce;
		uniform float _BorderVoronoi;
		uniform float2 _FallBorder;
		uniform float _WarterFallSpeed3;
		uniform float2 _StepsBorder;
		uniform float _VoroScale;
		uniform float _WaveOndulatingSpeed;
		uniform float _EdgeLength;


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


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


		float2 voronoihash204( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi204( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash204( n + g );
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


		float2 voronoihash167( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi167( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash167( n + g );
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


		float2 voronoihash58( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi58( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash58( n + g );
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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult79 = (float4(0.0 , ( _Time.w * _WarterFallSpeed ) , 0.0 , 0.0));
			float2 uv_TexCoord78 = i.uv_texcoord * _TextureScaling + appendResult79.xy;
			float4 WaterFalling82 = tex2D( _TextureSample0, uv_TexCoord78 );
			Gradient gradient47 = NewGradient( 0, 2, 2, float4( 1, 1, 1, 0 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0.8 ), float2( 0, 0.9000076 ), 0, 0, 0, 0, 0, 0 );
			Gradient gradient101 = NewGradient( 0, 2, 2, float4( 1, 1, 1, 0 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 0, 0.1000076 ), float2( 1, 0.2 ), 0, 0, 0, 0, 0, 0 );
			float transparency53 = ( SampleGradient( gradient47, i.uv_texcoord.x ).a * SampleGradient( gradient101, i.uv_texcoord.x ).a );
			float time2 = 0.0;
			float4 appendResult124 = (float4(0.0 , ( _Time.w * _WarterFallSpeed2 ) , 0.0 , 0.0));
			float2 uv_TexCoord125 = i.uv_texcoord * _Fall2Tiling + appendResult124.xy;
			float2 YFalling2126 = uv_TexCoord125;
			float2 coords2 = YFalling2126 * _HighWavesVoronoi;
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
			float HighWave1197 = ( ( step( voroi2 , _Steps.x ) - step( voroi2 , _Steps.y ) ) * _HighWavesForce );
			float time204 = 0.0;
			float2 coords204 = YFalling2126 * _HighWavesVoronoi2;
			float2 id204 = 0;
			float2 uv204 = 0;
			float fade204 = 0.5;
			float voroi204 = 0;
			float rest204 = 0;
			for( int it204 = 0; it204 <8; it204++ ){
			voroi204 += fade204 * voronoi204( coords204, time204, id204, uv204, 0 );
			rest204 += fade204;
			coords204 *= 2;
			fade204 *= 0.5;
			}//Voronoi204
			voroi204 /= rest204;
			float HighWave2210 = ( ( step( voroi204 , _Steps2.x ) - step( voroi204 , _Steps2.y ) ) * _HighWavesForce2 );
			Gradient gradient184 = NewGradient( 0, 2, 2, float4( 1, 1, 1, 0 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0.5000076 ), float2( 0, 1 ), 0, 0, 0, 0, 0, 0 );
			Gradient gradient190 = NewGradient( 0, 2, 2, float4( 1, 1, 1, 0 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 0, 0 ), float2( 1, 0.5000076 ), 0, 0, 0, 0, 0, 0 );
			float time167 = 0.0;
			float4 appendResult157 = (float4(0.0 , ( _Time.w * _WarterFallSpeed3 ) , 0.0 , 0.0));
			float2 uv_TexCoord158 = i.uv_texcoord * _FallBorder + appendResult157.xy;
			float2 YBorder160 = uv_TexCoord158;
			float2 coords167 = YBorder160 * _BorderVoronoi;
			float2 id167 = 0;
			float2 uv167 = 0;
			float fade167 = 0.5;
			float voroi167 = 0;
			float rest167 = 0;
			for( int it167 = 0; it167 <8; it167++ ){
			voroi167 += fade167 * voronoi167( coords167, time167, id167, uv167, 0 );
			rest167 += fade167;
			coords167 *= 2;
			fade167 *= 0.5;
			}//Voronoi167
			voroi167 /= rest167;
			float4 BORDER194 = ( _WaterBorder * _BorderForce * ( ( ( 1.0 - transparency53 ) * ( SampleGradient( gradient184, i.uv_texcoord.x ).a * SampleGradient( gradient190, i.uv_texcoord.x ).a ) ) * ( step( voroi167 , _StepsBorder.x ) - step( voroi167 , _StepsBorder.y ) ) ) );
			o.Emission = ( ( ( _WaterFallColor * ( WaterFalling82 * _TextureForce ) ) + ( _LittleWater * transparency53 ) + HighWave1197 + HighWave2210 ) + BORDER194 ).rgb;
			float time58 = ( _Time.y * _WaveOndulatingSpeed );
			float2 YFalling93 = uv_TexCoord78;
			float2 coords58 = YFalling93 * _VoroScale;
			float2 id58 = 0;
			float2 uv58 = 0;
			float fade58 = 0.5;
			float voroi58 = 0;
			float rest58 = 0;
			for( int it58 = 0; it58 <8; it58++ ){
			voroi58 += fade58 * voronoi58( coords58, time58, id58, uv58, 0 );
			rest58 += fade58;
			coords58 *= 2;
			fade58 *= 0.5;
			}//Voronoi58
			voroi58 /= rest58;
			float limited_high_wave49 = ( transparency53 * voroi58 );
			o.Alpha = ( transparency53 + limited_high_wave49 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
-1920;2;1920;1019;1054.472;349.6647;1.6;True;True
Node;AmplifyShaderEditor.CommentaryNode;199;-3863.714,-213.2943;Inherit;False;1190.809;426.6148;BorderFall;7;154;155;156;159;157;158;160;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;83;-3889.706,-1102.846;Inherit;False;1568.438;832.3676;WaterFall;16;78;79;81;80;77;82;1;93;121;122;123;124;125;126;153;212;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;154;-3813.714,-127.0468;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;155;-3813.237,98.32048;Inherit;False;Property;_WarterFallSpeed3;WarterFallSpeed3;16;0;Create;True;0;0;False;0;False;0.1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-3828.872,-479.9419;Inherit;False;Property;_WarterFallSpeed2;WarterFallSpeed2;15;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;121;-3829.349,-705.3091;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-3571.643,-12.37615;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-3587.278,-590.6385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;47;-1823.478,-2039.453;Inherit;False;0;2;2;1,1,1,0;1,1,1,1;1,0.8;0,0.9000076;0;1;OBJECT;0
Node;AmplifyShaderEditor.DynamicAppendNode;124;-3388.184,-605.4565;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;157;-3372.549,-27.19414;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;43;-1959.009,-1802.806;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;153;-3804.439,-397.8844;Inherit;False;Property;_Fall2Tiling;Fall2Tiling;21;0;Create;True;0;0;False;0;False;5,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GradientNode;101;-1881.017,-1948.837;Inherit;False;0;2;2;1,1,1,0;1,1,1,1;0,0.1000076;1,0.2;0;1;OBJECT;0
Node;AmplifyShaderEditor.Vector2Node;159;-3501.655,-163.2943;Inherit;False;Property;_FallBorder;FallBorder;22;0;Create;True;0;0;False;0;False;10,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;77;-3839.706,-1052.846;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;158;-3191.375,-77.26353;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;46;-1419.22,-1747.509;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;125;-3207.01,-655.5259;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;-3839.229,-827.4789;Inherit;False;Property;_WarterFallSpeed;WarterFallSpeed;14;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;41;-1409.313,-1978.073;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;200;-6366.227,1190.677;Inherit;False;1928.116;839.2651;Comment;10;210;209;208;207;206;205;204;203;202;201;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-3597.635,-938.1754;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-2949.938,-565.5743;Inherit;False;YFalling2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;193;-7677.8,-1547.209;Inherit;False;3441.404;1526.064;BORDER;21;176;172;173;191;171;170;169;167;168;166;188;187;161;186;162;185;163;190;184;182;194;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1022.431,-1885.349;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;196;-6382.641,265.0756;Inherit;False;1928.116;839.2651;Comment;10;117;120;144;142;143;2;152;20;111;197;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-2916.904,-84.19748;Inherit;True;YBorder;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-6232.577,-667.4486;Inherit;False;Property;_BorderVoronoi;BorderVoronoi;10;0;Create;True;0;0;False;0;False;3.63;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-6178.361,1355.772;Inherit;False;Property;_HighWavesVoronoi2;HighWavesVoronoi2;24;0;Create;True;0;0;False;0;False;0.91;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;182;-7627.8,-831.907;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-6114.912,420.1875;Inherit;False;Property;_HighWavesVoronoi;HighWavesVoronoi;9;0;Create;True;0;0;False;0;False;3.63;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-6332.641,323.8224;Inherit;False;126;YFalling2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GradientNode;190;-7565.586,-644.3754;Inherit;False;0;2;2;1,1,1,0;1,1,1,1;0,0;1,0.5000076;0;1;OBJECT;0
Node;AmplifyShaderEditor.Vector2Node;212;-3478.144,-776.8617;Inherit;False;Property;_TextureScaling;TextureScaling;23;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-725.8478,-1876.917;Inherit;True;transparency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-6316.227,1249.424;Inherit;False;126;YFalling2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;-6082.881,-968.8307;Inherit;True;160;YBorder;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-3398.541,-952.9933;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GradientNode;184;-7555.739,-1000.708;Inherit;False;0;2;2;1,1,1,0;1,1,1,1;1,0.5000076;0,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.Vector2Node;168;-5894.036,-324.9197;Inherit;False;Property;_StepsBorder;StepsBorder;20;0;Create;True;0;0;False;0;False;0.5,0.18;0.11,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GradientSampleNode;186;-7151.481,-708.7629;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;152;-5895.65,770.3394;Inherit;False;Property;_Steps;Steps;19;0;Create;True;0;0;False;0;False;0.5,0.23;0.11,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;204;-5868.813,1240.677;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GradientSampleNode;185;-7141.575,-939.3275;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-3219.367,-848.0627;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;2;-5885.227,315.0757;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector2Node;203;-5879.236,1695.941;Inherit;False;Property;_Steps2;Steps2;26;0;Create;True;0;0;False;0;False;0.5,0.23;0.11,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VoronoiNode;167;-5895.539,-693.3215;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GetLocalVarNode;162;-7256.068,-1497.209;Inherit;True;53;transparency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-6750.816,-846.6033;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2981.762,-1025.355;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;False;-1;a204ab092daef50448efeb699911744d;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;143;-5509.01,564.5948;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;170;-5513.514,-288.867;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;142;-5516.567,806.3922;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;205;-5492.596,1490.196;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;169;-5505.957,-530.6653;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;161;-6958.662,-1454.929;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1011.985,-1402.916;Inherit;False;Property;_WaveOndulatingSpeed;WaveOndulatingSpeed;13;0;Create;True;0;0;False;0;False;2;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-2952.299,-791.2807;Inherit;False;YFalling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;206;-5500.153,1731.994;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;56;-1043.434,-1621.661;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;120;-6017.185,637.0357;Inherit;False;Property;_HighWavesForce;HighWavesForce;11;0;Create;True;0;0;False;0;False;2.86;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;207;-5209.154,1617.994;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-6001.771,1562.637;Inherit;False;Property;_HighWavesForce2;HighWavesForce2;25;0;Create;True;0;0;False;0;False;2.86;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-6484.584,-1157.307;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;144;-5225.568,692.3925;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;171;-5247.647,-406.4573;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-587.7119,-1259.6;Inherit;False;Property;_VoroScale;VoroScale;17;0;Create;True;0;0;False;0;False;5;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-2634.168,-1001.904;Inherit;False;WaterFalling;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-636.913,-1494.25;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-682.7395,-1592.766;Inherit;False;93;YFalling;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-4932.242,475.7776;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;31.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;173;-5314.475,-1102.236;Inherit;False;Property;_WaterBorder;WaterBorder;6;0;Create;True;0;0;False;0;False;0.5773503,0.5773503,0.5773503,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;58;-364.6209,-1650.918;Inherit;True;0;0;1;3;8;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-4915.828,1401.379;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;31.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-5532.534,-666.62;Inherit;False;Property;_BorderForce;BorderForce;12;0;Create;True;0;0;False;0;False;2.86;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;-5236.307,-869.6038;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-1569.684,68.94969;Inherit;False;Property;_TextureForce;TextureForce;18;0;Create;True;0;0;False;0;False;5.6;5.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-1593.729,-162.945;Inherit;True;82;WaterFalling;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;-4683.459,1404.303;Inherit;False;HighWave2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-815.5612,429.5808;Inherit;False;53;transparency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;-4918.959,-973.5026;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;334.0308,-1680.668;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1282.684,-131.0503;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-4698.873,477.7014;Inherit;False;HighWave1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-797.4639,162.7928;Inherit;False;Property;_LittleWater;LittleWater;7;0;Create;True;0;0;False;0;False;0.5773503,0.5773503,0.5773503,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-1348.346,-408.4544;Inherit;False;Property;_WaterFallColor;WaterFallColor;8;0;Create;True;0;0;False;0;False;0.5773503,0.5773503,0.5773503,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-4583.324,-957.4271;Inherit;False;BORDER;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-675.0005,-201.8768;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-449.6755,563.3417;Inherit;False;210;HighWave2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;636.751,-1721.827;Inherit;False;limited_high_wave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-481.3285,190.3263;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-452.9924,484.7187;Inherit;False;197;HighWave1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-156.0795,217.7064;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;265.4412,1077.812;Inherit;False;53;transparency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-9.228638,893.1401;Inherit;True;49;limited_high_wave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;-3891.367,-1657.459;Inherit;False;1759.68;485.1123;high wave;7;36;4;26;23;32;30;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-82.24622,589.2793;Inherit;False;194;BORDER;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;23;-3841.367,-1607.459;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-3347.53,-1503.164;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.59;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-2366.702,-1491.951;Inherit;False;high_wave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;32;-3602.106,-1543.203;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;166.5726,-931.9766;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.59;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;4;-2619.198,-1492.348;Inherit;True;0;0;1;3;2;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.DynamicAppendNode;27;-3082.316,-1483.22;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;10.61047,-1229.689;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;181;569.2755,1076.186;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;247;-1372.748,-1147.568;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientSampleNode;248;-1362.841,-1378.132;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0.71;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-2879.657,-1503.629;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;250;-611.799,-1127.153;Inherit;True;transparencyX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;-907.7228,-1180.141;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;252;371.3508,-1209.138;Inherit;False;limited_high_waveX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;178;245.8451,450.0214;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1562.4,457.1999;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Cascade;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;156;0;154;4
WireConnection;156;1;155;0
WireConnection;123;0;121;4
WireConnection;123;1;122;0
WireConnection;124;1;123;0
WireConnection;157;1;156;0
WireConnection;158;0;159;0
WireConnection;158;1;157;0
WireConnection;46;0;101;0
WireConnection;46;1;43;1
WireConnection;125;0;153;0
WireConnection;125;1;124;0
WireConnection;41;0;47;0
WireConnection;41;1;43;1
WireConnection;81;0;77;4
WireConnection;81;1;80;0
WireConnection;126;0;125;0
WireConnection;39;0;41;4
WireConnection;39;1;46;4
WireConnection;160;0;158;0
WireConnection;53;0;39;0
WireConnection;79;1;81;0
WireConnection;186;0;190;0
WireConnection;186;1;182;1
WireConnection;204;0;201;0
WireConnection;204;2;202;0
WireConnection;185;0;184;0
WireConnection;185;1;182;1
WireConnection;78;0;212;0
WireConnection;78;1;79;0
WireConnection;2;0;111;0
WireConnection;2;2;20;0
WireConnection;167;0;163;0
WireConnection;167;2;166;0
WireConnection;187;0;185;4
WireConnection;187;1;186;4
WireConnection;1;1;78;0
WireConnection;143;0;2;0
WireConnection;143;1;152;1
WireConnection;170;0;167;0
WireConnection;170;1;168;2
WireConnection;142;0;2;0
WireConnection;142;1;152;2
WireConnection;205;0;204;0
WireConnection;205;1;203;1
WireConnection;169;0;167;0
WireConnection;169;1;168;1
WireConnection;161;0;162;0
WireConnection;93;0;78;0
WireConnection;206;0;204;0
WireConnection;206;1;203;2
WireConnection;207;0;205;0
WireConnection;207;1;206;0
WireConnection;188;0;161;0
WireConnection;188;1;187;0
WireConnection;144;0;143;0
WireConnection;144;1;142;0
WireConnection;171;0;169;0
WireConnection;171;1;170;0
WireConnection;82;0;1;0
WireConnection;67;0;56;2
WireConnection;67;1;75;0
WireConnection;117;0;144;0
WireConnection;117;1;120;0
WireConnection;58;0;94;0
WireConnection;58;1;67;0
WireConnection;58;2;87;0
WireConnection;209;0;207;0
WireConnection;209;1;208;0
WireConnection;191;0;188;0
WireConnection;191;1;171;0
WireConnection;210;0;209;0
WireConnection;176;0;173;0
WireConnection;176;1;172;0
WireConnection;176;2;191;0
WireConnection;59;0;53;0
WireConnection;59;1;58;0
WireConnection;129;0;84;0
WireConnection;129;1;131;0
WireConnection;197;0;117;0
WireConnection;194;0;176;0
WireConnection;22;0;21;0
WireConnection;22;1;129;0
WireConnection;49;0;59;0
WireConnection;7;0;10;0
WireConnection;7;1;118;0
WireConnection;119;0;22;0
WireConnection;119;1;7;0
WireConnection;119;2;198;0
WireConnection;119;3;211;0
WireConnection;30;0;32;0
WireConnection;36;0;4;0
WireConnection;32;0;23;4
WireConnection;4;0;26;0
WireConnection;27;0;30;0
WireConnection;251;0;58;0
WireConnection;251;1;250;0
WireConnection;181;0;192;0
WireConnection;181;1;76;0
WireConnection;247;0;101;0
WireConnection;247;1;43;2
WireConnection;248;0;101;0
WireConnection;248;1;43;2
WireConnection;26;1;27;0
WireConnection;250;0;249;0
WireConnection;249;0;248;4
WireConnection;249;1;247;4
WireConnection;252;0;251;0
WireConnection;178;0;119;0
WireConnection;178;1;195;0
WireConnection;0;2;178;0
WireConnection;0;9;181;0
ASEEND*/
//CHKSM=845CFF9CA4B20CFFC756DAE7B1321642BE3361D8
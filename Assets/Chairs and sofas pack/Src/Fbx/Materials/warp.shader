Shader "Custom/warp" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
			Cull off
			Pass {
			Name "Custom/warp"
			Lighting On
		
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.0

            #include "UnityCG.cginc"         
                
            sampler2D _MainTex;
               
            struct v2f
		    {
		        float4 pos : POSITION; // position
		        float3 color : COLOR;  // color
		        float2  uv : TEXCOORD0;// texture
		    }; 

			float4 _MainTex_ST;
			
			v2f vert (appdata_base v)
			{
			    v2f o;

				//Language reference is at: http://http.developer.nvidia.com/CgTutorial/cg_tutorial_appendix_e.html

				////////////////Begin warping - version 1
				//We will do all our work in camera space
				//Get the original vertex, in camera space
				//transform position from object space to eye space
/*				const float4 w = mul( UNITY_MATRIX_MV, v.vertex); //model and view
				
				////WARPING ALGORITHM STARTS HERE
				//w_mag appears to be correct // Get the original distnace of the vertex from camera
				const float w_mag = length(w);
				const float4 camera_direction = float4(0.0,0.0,-w_mag,1.0);
				
				 float warp_amount = min(w_mag/20.0, 1.0);
				 if(w.z > 0.0){
				  warp_amount = 0.0;
				  }
				//warp_amount = 0.0; //COMMENT/UNCOMMENT TO CHANGE WHETHER WARPING OR NOTs
				const float4 w_warped = lerp(w,camera_direction,warp_amount); 
				//const float4 w_warped = w_mag * normalize(lerp(w,camera_direction,warp_amount)); // (1- warp_amount) * w + warp_amount * camera_direction				
			    ////WARPING ALGORITHM ENDS HERE
			    
			 
			    
			    o.pos = mul( UNITY_MATRIX_P, w_warped);//w_warped);*/
			    //end warping - vesrion 1

				//begin warping - version 2
				const float4 p_o_1 = mul(UNITY_MATRIX_MV, v.vertex); //model and view
				const float4 p_orig = p_o_1; // float4(4.0 / sqrt(2.0), 4.0 / sqrt(2.0), 3.0, 0);//mul(UNITY_MATRIX_MV, v.vertex); //model and view
				float4 p_res;
				const float view_z = -2.0;

				const float4 p_xvec = float4(p_orig.x, p_orig.y, 0.0, 0.0);
				if (length(p_xvec) > 0.0) {
					const float4 p_xvec_n = normalize(p_xvec);
					const float x_circ1 = dot(p_orig, p_xvec_n); //Project point onto coordinate system of the circle. y is always 0
					const float4 p_toWork = float4(x_circ1, 0, p_orig.z, 0.0);

					if (p_toWork.x > 0.0) {
						const float signed_r = 0.5*(p_toWork.x + p_toWork.z*p_toWork.z / p_toWork.x);
						const float x_minus_r = p_toWork.x - signed_r;
						const float a = sqrt(x_minus_r*x_minus_r + p_toWork.z*p_toWork.z - view_z*view_z);
						const float x_prime = signed_r - sign(signed_r)*a;
						//TODO: Use appropriate source of PI
						const float theta = 3.1415927 - atan2(sign(view_z)*p_toWork.z, sign(signed_r)*x_minus_r);
						const float mag = max(length(p_toWork), theta*abs(signed_r));
						
						const float4 p_new = float4(x_prime, 0.0, view_z, 0.0);
						const float4 p_new2 = mag*normalize(p_new);

						const float4 p_final = float4(p_new2.x*p_xvec_n.x, p_new2.x*p_xvec_n.y, p_new2.z, 1.0);
						p_res = p_final;
					}
					else {
						p_res = p_orig;
					}
				}
				else {
					p_res = p_orig;
				}
				
				o.pos = mul(UNITY_MATRIX_P, p_res);
				//end warping - version 2
			    
			    o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
				o.color = ShadeVertexLights(v.vertex, v.normal);
			    
			    return o;
			}
			
		
			

			float4 frag(v2f i) : COLOR
			{
			    half4 texcol = tex2D (_MainTex, i.uv);
			    texcol.rgb = texcol.rgb/2 + texcol.rgb * i.color;
			    return texcol;	 
			}

			ENDCG
		}
	}
	
	FallBack "Diffuse"
}

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
				const float4 w = mul( UNITY_MATRIX_MV, v.vertex); //model and view
				
				////WARPING ALGORITHM STARTS HERE
				//w_mag appears to be correct // Get the original distnace of the vertex from camera
				const float w_mag = length(w);
				const float4 camera_direction = float4(0.0,0.0,sign(w.z)*w_mag,1.0);
				
				float warp_amount = min(w_mag/20.0, 1.0);

				const float thetac = atan2(w.z, 0);
				const float thetaw = atan2(w.z, w.x);
				const float thingLen = length(float4(w.x, w.z, 0, 0));
				const float thetaWarped = lerp(thetaw, thetac, warp_amount);

				const float4 p_res = w_mag*normalize(float4(thingLen*cos(thetaWarped), w.y, thingLen*sin(thetaWarped), 1.0));
				//warp_amount = 0.0; //COMMENT/UNCOMMENT TO CHANGE WHETHER WARPING OR NOTs
				//const float4 p_res = lerp(w,camera_direction,warp_amount); 
				//const float4 w_warped = w_mag * normalize(lerp(w,camera_direction,warp_amount)); // (1- warp_amount) * w + warp_amount * camera_direction				
			    ////WARPING ALGORITHM ENDS HERE
			    //end warping - vesrion 1

				//begin warping - version 2
				//const float4 p_orig = mul(UNITY_MATRIX_MV, v.vertex); //model and view
				//float4 p_res = p_orig;
				//const float view_z = -1.0;

				//const float4 p_xvec = float4((p_orig.x), (p_orig.y), 0.0, 0.0);
				//if (p_orig.z <= 0 && length(p_xvec) > 0.0) {
				//	const float4 p_xvec_n = normalize(p_xvec);
				//	const float x_plane = dot(p_orig, p_xvec_n); //Project point onto coordinate system of the plane. y is always 0
				//	const float4 p_toWork = float4(x_plane, 0, p_orig.z, 0.0);

				//	if (abs(p_toWork.x/p_toWork.z) > 0.001) {
				//		const float x = p_toWork.x;
				//		const float y = p_toWork.z;
				//		
				//		//Begin square root	
				//		/*const float m = abs(y)/sqrt(abs(x));
				//		const float z = 2*abs(y)/(m*m);
				//		const float arcsinh = log(z+sqrt(1+z*z));
				//		const float mag = abs((1.0/4)*(2*abs(y)*sqrt(1+4*y*y/(m*m*m*m))+m*m*arcsinh));
				//		const float x_prime = (view_z*view_z)/(m*m);*/
				//		//end square root
				//		
				//		//begin x^(3/4)
				//		//TODO: Seems to be a bug when x is very close to 0.
				//		/*const float m = abs(y)/pow(abs(x),3.0/4);
				//		const float z = (4.0/3)*pow(abs(y)/(m*m*m*m),1.0/3);
				//		const float arcsinh = log(z+sqrt(1+z*z));
				//		const float mag = (1.0/(512*pow(m,4.0/3)))*
				//			((4.0*sqrt(9*pow(m,8.0/3) + 16*pow(abs(y),2.0/3))*
				//		     (32*abs(y)+9*pow((pow(m,8.0)*abs(y)),1.0/3))) 
				//				- (81*pow(m,16.0/3)*arcsinh));
				//		const float x_prime = pow(abs(view_z),4.0/3)/pow(m,4.0/3);*/
				//		//end x^(3/4)
				//		
				//		const float4 p_new = mag*normalize(float4(sign(x)*x_prime,0,view_z,0));
				//		
				//		const float4 p_final = float4(p_new.x*p_xvec_n.x, p_new.x*p_xvec_n.y, p_new.z, 1.0);
				//		p_res = p_final;
				//		
				//		//o.color = float4(abs(mag_2 + 20.3961) < 0.0001 ? 1 : 0,0,0,1);
				//		
				//	}
				//} 
				
				
				/*if (length(p_xvec) > 0.0) {
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
				}*/
				
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

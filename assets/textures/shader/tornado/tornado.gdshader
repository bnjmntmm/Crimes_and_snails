shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D Noise;
uniform sampler2D Mask;
uniform float FloatParameter : hint_range(0, 1, 0.05000000074506) = 0.10000000149012;



void vertex() {
	mat4 n_out2p0;
// GetBillboardMatrix:2
	{
		mat4 __wm = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]), normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
		__wm = __wm * mat4(vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
		n_out2p0 = VIEW_MATRIX * __wm;
	}


// Output:0
	MODELVIEW_MATRIX = n_out2p0;

}

void fragment() {
// Input:2
	vec4 n_out2p0 = COLOR;


// FloatConstant:11
	float n_out11p0 = 0.000000;


	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(Noise, UV);


	vec4 n_out5p0;
// Texture2D:5
	n_out5p0 = texture(Mask, UV);


// Mix:10
	vec4 n_in10p2 = vec4(0.50000, 0.50000, 0.50000, 0.50000);
	vec4 n_out10p0 = mix(n_out3p0, n_out5p0, n_in10p2);


// FloatParameter:9
	float n_out9p0 = FloatParameter;


// SmoothStep:8
	vec4 n_out8p0 = smoothstep(vec4(n_out11p0), n_out10p0, vec4(n_out9p0));


// Output:0
	ALBEDO = vec3(n_out2p0.xyz);
	ALPHA = n_out8p0.x;
	

}

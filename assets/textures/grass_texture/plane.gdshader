shader_type spatial;

uniform float height_scale = 0.4;
uniform sampler2D displacement;
uniform sampler2D color;

varying vec2 tex_position;

void vertex() {
  tex_position = VERTEX.xz / 2.0 + 0.5;
  float height = texture(displacement, tex_position).x;
  VERTEX.y += height * height_scale;
}

void fragment(){
	
	ALBEDO = texture(color,tex_position).xyz * vec3(0.3,0.3,0.3);
}
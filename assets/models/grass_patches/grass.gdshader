shader_type spatial;
render_mode cull_disabled;

uniform vec3 color : source_color;
uniform vec3 color2 : source_color;
uniform sampler2D noise;
uniform float noiseScale = 20.0;
uniform vec2 windDirection = vec2(1.0, 0.0); // Windrichtung
uniform float windThreshold = 0.5;
varying vec3 worldPos;

void vertex() {
	float offset = TIME * 0.1;
	float noiseValue = texture(noise, vec2(VERTEX.xz / noiseScale + offset)).r;
	VERTEX.x += noiseValue * 0.01;
	
	//check if y-coords over threshold
	if (VERTEX.y > windThreshold){
		//windeffekt anwenden
		float windEffect = sin(TIME*1.2) * 0.1;
		VERTEX.y += windEffect;
	}
	
	worldPos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	vec3 noiseLevel = texture(noise, worldPos.xz / noiseScale).rgb;
	ALBEDO = mix(color, color2, UV.y) * mix(color, color2, noiseLevel.r);
	if (!FRONT_FACING){
		NORMAL = -NORMAL;
	}
}

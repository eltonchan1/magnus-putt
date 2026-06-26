shader_type canvas_item;

uniform int transition_type = 0; // 0 = bars, 1 = circle
uniform float progress: hint_range(0.0, 1.0) = 0.0;
uniform int bar_count = 10;
uniform float stagger = 0.15; // how much each bar is delayed

void fragment() {
	vec2 uv = UV;
	float alpha = 0.0;
	if (transition_type == 0) {
		// Staggered horizontal bars
		float bar_index = floor(uv.y * float(bar_count));
		float bar_uv = fract(uv.y * float(bar_count));
		float delay = (bar_index / float(bar_count)) * stagger;
		float bar_progress = clamp((progress - delay) / (1.0 - stagger), 0.0, 1.0);
		float edge = smoothstep(bar_progress - 0.02, bar_progress + 0.02, uv.x);
		alpha = 1.0 - edge;
	} else {
		vec2 center = vec2(0.5, 0.5);
		vec2 aspect_uv = vec2(uv.x, uv.y * (1080.0 / 1920.0));
		vec2 aspect_center = vec2(center.x, center.y * (1080.0 / 1920.0));
		float dist = distance(aspect_uv, aspect_center);        
		float max_dist = distance(vec2(0.0, 0.0), aspect_center);
		float normalized_dist = dist / max_dist;
		float edge_softness = 0.03;
		alpha = smoothstep(
			progress - edge_softness,
			progress + edge_softness,
			normalized_dist
		);
	}
	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
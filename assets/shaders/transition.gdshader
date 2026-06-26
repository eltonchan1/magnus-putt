shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform int bar_count = 3;
uniform vec4 bar_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool covering = true;

void fragment() {
	float bar_index = floor(UV.y * float(bar_count));
	float stagger = bar_index / float(bar_count) * 0.3;
	float bar_progress = clamp((progress - stagger) / (1.0 - 0.3), 0.0, 1.0);
	bool covered;
	if (covering) {
		covered = UV.x < bar_progress;
	} else {
		covered = UV.x < (1.0 - bar_progress);
	}
	if (covered) {
		COLOR = bar_color;
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}
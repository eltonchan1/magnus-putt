extends CanvasLayer

@onready var shader_rect: ColorRect = $shaderrect

enum Type { BARS, CIRCLE }

var is_transitioning: bool = false
var shader_material: ShaderMaterial

const TRANSITION_DURATION: float = 0.45
const REVEAL_DURATION: float = 0.45

func _ready():
	shader_material = ShaderMaterial.new()
	shader_material.shader = preload("res://assets/shaders/transition.gdshader")
	shader_rect.material = shader_material
	shader_material.set_shader_parameter("progress", 0.0)
	shader_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func go_to(path: String, type: Type = Type.BARS):
	if is_transitioning:
		return
	is_transitioning = true
	shader_rect.mouse_filter = Control.MOUSE_FILTER_STOP  # block input during transition
	
	await _play_in(type)
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame  # wait one frame for scene to load
	await _play_out(type)
	
	is_transitioning = false
	shader_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _play_in(type: Type):
	shader_material.set_shader_parameter("transition_type", type)
	var tween = create_tween()
	tween.tween_method(
		func(v): shader_material.set_shader_parameter("progress", v),
		0.0, 1.0, TRANSITION_DURATION
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await tween.finished

func _play_out(type: Type):
	shader_material.set_shader_parameter("transition_type", type)
	var tween = create_tween()
	tween.tween_method(
		func(v): shader_material.set_shader_parameter("progress", v),
		1.0, 0.0, REVEAL_DURATION
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished

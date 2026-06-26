extends CanvasLayer

@onready var rect = $transitionrect

var shader_mat: ShaderMaterial
var is_transitioning: bool = false

const TRANSITION_SHADER = preload("res://assets/shaders/transition.gdshader")
const COVER_DURATION = 0.5
const REVEAL_DURATION = 0.5

func _ready():
	shader_mat = ShaderMaterial.new()
	shader_mat.shader = TRANSITION_SHADER
	shader_mat.set_shader_parameter("progress", 0.0)
	shader_mat.set_shader_parameter("bar_count", 3)
	shader_mat.set_shader_parameter("bar_color", Color(0, 0, 0, 1))
	rect.material = shader_mat
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func go_to(scene_path: String):
	if is_transitioning:
		return
	is_transitioning = true
	rect.mouse_filter = Control.MOUSE_FILTER_STOP
	await _cover()
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	await _reveal()
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	is_transitioning = false

func _cover():
	var tween = create_tween()
	tween.tween_method(
		func(v): shader_mat.set_shader_parameter("progress", v),
		0.0, 1.0, COVER_DURATION
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _reveal():
	shader_mat.set_shader_parameter("covering", false)
	shader_mat.set_shader_parameter("progress", 0.0)
	var tween = create_tween()
	tween.tween_method(
		func(v): shader_mat.set_shader_parameter("progress", v),
		0.0, 1.0, REVEAL_DURATION
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	shader_mat.set_shader_parameter("covering", true)
	shader_mat.set_shader_parameter("progress", 0.0)

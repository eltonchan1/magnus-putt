extends Control

var spin_value: Vector2 = Vector2.ZERO
var is_dragging: bool = false
var handle_pos: Vector2 = Vector2.ZERO

const RADIUS: float = 50.0
const HANDLE_RADIUS: float = 10.0

signal spin_changed(spin: Vector2)

func _ready():
	size = Vector2(RADIUS * 2 + 20, RADIUS * 2 + 20)
	handle_pos = Vector2.ZERO

func get_center() -> Vector2:
	return size / 2.0

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				is_dragging = true
				_update_handle(event.position)
			else:
				is_dragging = false
	if event is InputEventMouseMotion:
		if is_dragging:
			_update_handle(event.position)

func _update_handle(mouse_pos: Vector2):
	var offset = mouse_pos - get_center()
	offset = offset.limit_length(RADIUS)
	handle_pos = offset
	spin_value = -(offset / RADIUS)
	emit_signal("spin_changed", spin_value)
	queue_redraw()

func reset():
	handle_pos = Vector2.ZERO
	spin_value = Vector2.ZERO
	is_dragging = false
	queue_redraw()

func _draw():
	var center = get_center()
	draw_circle(center, RADIUS, Color(1,1,1,0.1))
	draw_arc(center, RADIUS, 0, TAU, 64, Color(1,1,1,0.5), 2.0)
	draw_line(center + Vector2(-RADIUS, 0), center + Vector2(RADIUS, 0), Color(1,1,1,0.2), 1.0)
	draw_line(center + Vector2(0, -RADIUS), center + Vector2(0, RADIUS), Color(1,1,1,0.2), 1.0)
	var handle_color = Color(1, 0.8, 0.2) if handle_pos.length() > 2.0 else Color(1,1,1,0.4)
	draw_circle(center + handle_pos, HANDLE_RADIUS, handle_color)
	draw_arc(center + handle_pos, HANDLE_RADIUS, 0, TAU, 16, Color(1,1,1,0.8))
	if spin_value.length() > 0.05:
		draw_arc(center, spin_value.length() * RADIUS, 0, TAU, 32, Color(1,0.8,0.2,0.4), 2.0)
		var arrow_dir = Vector2(spin_value.x, -spin_value.y).normalized()
		var arrow_length = spin_value.length() * RADIUS * 0.7
		var arrow_end = center + arrow_dir * arrow_length
		draw_line(center, arrow_end, Color(0.2,1.0,0.5,0.9), 2.5)
		var head_size = 8.0
		var perp = Vector2(-arrow_dir.y, arrow_dir.x)
		var tip = arrow_end
		var left = arrow_end - arrow_dir * head_size + perp * head_size * 0.5
		var right = arrow_end - arrow_dir * head_size - perp * head_size * 0.5
		draw_colored_polygon(PackedVector2Array([tip, left, right]), Color(0.2,1.0,0.5,0.9))

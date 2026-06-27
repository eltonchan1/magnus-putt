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
		if event.button_index == MOUSE_BUTTON_LEFT:
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
	spin_value = Vector2(offset.x / RADIUS, -(offset.y / RADIUS))
	emit_signal("spin_changed", spin_value)
	queue_redraw()

func reset():
	handle_pos = Vector2.ZERO
	spin_value = Vector2.ZERO
	is_dragging = false
	queue_redraw()

func _draw():
	var center = get_center()
	draw_circle(center, RADIUS, Color(1,1,1,0.5))
	draw_arc(center, RADIUS, 0, TAU, 64, Color(1,1,1,1.0), 2.0)
	draw_line(center + Vector2(-RADIUS, 0), center + Vector2(RADIUS, 0), Color(1,1,1,0.4), 1.0)
	draw_line(center + Vector2(0, -RADIUS), center + Vector2(0, RADIUS), Color(1,1,1,0.4), 1.0)
	var dot_center = center + handle_pos
	if handle_pos.length() > 2.0:
		draw_line(center, dot_center, Color(1,1,1,1.0), 2.0)
	draw_circle(dot_center, HANDLE_RADIUS, Color(1,1,1,1.0))
	draw_arc(dot_center, HANDLE_RADIUS, 0, TAU, 16, Color(1,1,1,1.0))

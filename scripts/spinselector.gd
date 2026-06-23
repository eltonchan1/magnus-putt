extends Control

var spin := Vector2.ZERO
var is_dragging := false
var radius := 40.0

signal spin_changed(new_spin: Vector2)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(get_local_mouse_position()):
			is_dragging = true
		else:
			is_dragging = false
			spin = Vector2.ZERO
			spin_changed.emit(spin)
	if event is InputEventMouseMotion and is_dragging:
		var center = global_position + size / 2
		var offset = get_global_mouse_position() - center
		offset = offset.limit_length(radius)
		spin = offset / radius
		spin_changed.emit(spin)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

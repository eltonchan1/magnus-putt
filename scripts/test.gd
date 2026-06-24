extends Node2D

@onready var ball = $ball
@onready var spinselector = $spinselector

func _ready():
	spinselector.spin_changed.connect(_on_spin_changed)

func _on_spin_changed(spin: Vector2):
	if not ball.is_moving:
		ball.set_spin(spin)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				ball._try_start_aim(get_global_mouse_position())
			else:
				if ball.is_aiming:
					ball._release_shot(get_global_mouse_position())

	if event is InputEventMouseMotion:
		if ball.is_aiming:
			ball._update_aim(event.global_position)

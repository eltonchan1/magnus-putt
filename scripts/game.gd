extends Node2D

enum State { AIMING, BALL_MOVING }

var state = State.AIMING
var ball: RigidBody2D
var shot_count := 0
var aim_start: Vector2
var power := 0.0
var max_power := 600.0

func _ready() -> void:
	ball = $ball

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			aim_start = get_global_mouse_position()
		else:
			if state == State.AIMING:
				var direction = (aim_start - get_global_mouse_position()).normalized()
				ball.launch(direction, power, Vector2.ZERO)
				shot_count += 1
				state = State.BALL_MOVING
				print("shot fired, count ", shot_count, " power ", power, " dir ", direction)
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var drag = get_global_mouse_position() - aim_start
		power = clamp(drag.length(),  0, max_power)

func _physics_process(delta: float):
	if state == State.BALL_MOVING and (ball.linear_velocity).length() < 5.0:
		state = State.AIMING
		print("ball stopped")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Area2D

signal ball_holed

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	emit_signal("ball_holed")
	body.is_moving = false
	body.linear_velocity = Vector2.ZERO
	body.global_position = global_position

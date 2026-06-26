extends Area2D

signal ball_killed

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("ball"):
		emit_signal("ball_killed")

func _draw():
	var shape = $CollisionShape2D.shape as RectangleShape2D
	if shape:
		var rect = Rect2(-shape.size / 2.0, shape.size)
		draw_rect(rect, Color(0.8, 0.15, 0.15))
		draw_rect(rect, Color(1.0, 0.3, 0.3), false, 2.0)

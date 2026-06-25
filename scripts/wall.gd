extends StaticBody2D

@export var wall_color: Color = Color(0.4,0.45,0.55)

func _draw():
	var shape = $CollisionShape2D.shape as RectangleShape2D
	if shape:
		var rect = Rect2(-shape.size / 2.0, shape.size)
		draw_rect(rect, wall_color)
		draw_rect(rect, Color(0.6,0.65,0.75), false, 2.0)

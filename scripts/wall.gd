@tool
extends StaticBody2D

@export var wall_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var wall_size: Vector2 = Vector2(40,40)

func _ready():
	var shape = $CollisionShape2D.shape as RectangleShape2D
	shape.size = wall_size
	queue_redraw()

func _set(property, value):
	if property == "wall_size" or property == "wall_color":
		set(property, value)
		if $CollisionShape2D and $CollisionShape2D.shape:
			($CollisionShape2D.shape as RectangleShape2D).size = wall_size
		queue_redraw()
		return true
	return false

func _draw():
	var shape = $CollisionShape2D.shape as RectangleShape2D
	if shape:
		var rect = Rect2(-shape.size / 2.0, shape.size)
		draw_rect(rect, wall_color)

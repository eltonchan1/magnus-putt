extends Area2D

signal ball_killed

@onready var collision = $CollisionShape2D
@onready var static_body = $StaticBody2D
@onready var static_collision = $StaticBody2D/CollisionShape2D

func _ready():
	body_entered.connect(_on_body_entered)
	var level = get_tree().get_first_node_in_group("level")
	if level:
		ball_killed.connect(level._on_ball_killed)
	static_collision.shape = collision.shape

func _on_body_entered(body):
	emit_signal("ball_killed")

func _draw():
	var shape = $CollisionShape2D.shape as RectangleShape2D
	if shape:
		var rect = Rect2(-shape.size / 2.0, shape.size)
		draw_rect(rect, Color(0.8, 0.15, 0.15))

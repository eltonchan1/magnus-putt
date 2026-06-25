extends Node2D

@export var level_data: LevelData

var shot_count: int = 0
var par: int = 3

@onready var ball = $ball
@onready var spinselector = $spinselector
@onready var hole = $hole
@onready var hud = $hud
@onready var win_screen = $winscreen

func _ready():
	spinselector.spin_changed.connect(_on_spin_changed)
	hole.ball_holed.connect(_on_ball_holed)
	win_screen.retry_pressed.connect(_on_retry)
	win_screen.next_pressed.connect(_on_next)
	win_screen.menu_pressed.connect(_on_menu)
	hud.setup(par)

func _on_spin_changed(spin: Vector2):
	if not ball.is_moving:
		ball.set_spin(spin)

func _on_ball_holed():
	hud.update_shots(shot_count)
	print("holed, shots taken: ", shot_count, " shots vs par ", par)
	print("ball holed signal received")
	win_screen.show_results(level_data, shot_count)

func _on_retry():
	get_tree().reload_current_scene()

func _on_next():
	get_tree().change_scene_to_file(level_data.next_level)

func _on_menu():
	get_tree().change_scene_to_file("res://scenes/ui/mainmenu.tscn")

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				ball._try_start_aim(get_global_mouse_position())
			else:
				if ball.is_aiming:
					ball._release_shot(get_global_mouse_position())
					shot_count += 1
					hud.update_shots(shot_count)
	if event is InputEventMouseMotion:
		if ball.is_aiming:
			ball._update_aim(event.global_position)

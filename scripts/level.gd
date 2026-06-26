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
	hud.retry_pressed.connect(func():
		scenetransition.go_to(level_data.scene_path)
	)
	hud.menu_pressed.connect(func():
		scenetransition.go_to("res://scenes/ui/main_menu.tscn")
	)
	hud.options_pressed.connect(func():
		settingsmanager.options_return_scene = level_data.scene_path
		scenetransition.go_to("res://scenes/ui/options.tscn", scenetransition.Type.CIRCLE)
	)
	hud.setup(par)
	for brick in get_tree().get_nodes_in_group("kill_brick"):
		brick.ball_killed.connect(_on_ball_killed)

func _on_spin_changed(spin: Vector2):
	if not ball.is_moving:
		ball.set_spin(spin)

func _on_ball_holed():
	hud.update_shots(shot_count)
	print("holed, shots taken: ", shot_count, " shots vs par ", par)
	print("ball holed signal received")
	win_screen.show_results(level_data, shot_count)

func _on_retry():
	scenetransition.go_to(level_data.scene_path)

func _on_next():
	scenetransition.go_to(level_data.next_level)

func _on_menu():
	scenetransition.go_to("res://scenes/ui/levelselect.tscn")

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

func _on_ball_killed():
	scenetransition.go_to(level_data.scene_path)

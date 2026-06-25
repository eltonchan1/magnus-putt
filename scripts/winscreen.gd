extends CanvasLayer

@onready var title_label = $ColorRect/VBoxContainer/titlelabel
@onready var score_label = $ColorRect/VBoxContainer/scorelabel
@onready var stars_label = $ColorRect/VBoxContainer/starslabel
@onready var next_button = $ColorRect/VBoxContainer/nextbutton
@onready var retry_button = $ColorRect/VBoxContainer/retrybutton
@onready var menu_button = $ColorRect/VBoxContainer/menubutton

signal retry_pressed
signal next_pressed
signal menu_pressed

func show_results(level_data: LevelData, shots: int):
	var stars = _calculate_stars(level_data.par, shots)
	savemanager.save_level(level_data.level_id, shots, stars)
	title_label.text = level_data.level_name
	score_label.text = "%d shots  (Par %d)" % [shots, level_data.par]
	stars_label.text = _stars_string(stars)
	var best = savemanager.get_best_shots(level_data.level_id)
	if best < shots:
		score_label.text += "  (BEST: %d)" % best
	next_button.visible = level_data.next_level != ""
	visible = true

func _calculate_stars(par: int, shots: int) -> int:
	if shots <= par - 2:
		return 3
	elif shots <= par:
		return 2
	elif shots <= par + 2:
		return 1
	else:
		return 0

func _stars_string(stars: int) -> String:
	var filled = "★".repeat(stars)
	var empty = "☆".repeat(3 - stars)
	return filled + empty

func _ready():
	visible = false
	next_button.pressed.connect(func(): emit_signal("next_pressed"))
	retry_button.pressed.connect(func(): emit_signal("retry_pressed"))
	menu_button.pressed.connect(func(): emit_signal("menu_pressed"))

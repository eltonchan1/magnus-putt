extends PanelContainer

signal card_pressed(level_data: LevelData)

@onready var preview = $VBoxContainer/preview
@onready var name_label = $VBoxContainer/namelabel
@onready var stars_label = $VBoxContainer/HBoxContainer/starslabel
@onready var shots_label = $VBoxContainer/HBoxContainer/shotslabel

var level_data: LevelData = null

func setup(data: LevelData):
	level_data = data
	name_label.text = data.level_name
	if data.preview_image:
		preview.texture = data.preview_image
	else:
		preview.modulate = Color(0.2, 0.2, 0.2)  # dark placeholder
	var completed = savemanager.is_completed(data.level_id)
	if completed:
		var stars = savemanager.get_stars(data.level_id)
		var best = savemanager.get_best_shots(data.level_id)
		stars_label.text = _stars_string(stars)
		shots_label.text = "Best: %d" % best
	else:
		stars_label.text = "☆☆☆"
		shots_label.text = "Not played"
	
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("card_pressed", level_data)

func _stars_string(stars: int) -> String:
	return "★".repeat(stars) + "☆".repeat(3 - stars)

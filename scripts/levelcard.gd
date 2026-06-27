extends PanelContainer

signal card_pressed(level_data: LevelData)

@onready var preview = $VBoxContainer/preview
@onready var name_label = $VBoxContainer/namelabel
@onready var shots_label = $VBoxContainer/shotslabel

var level_data: LevelData = null

func setup(data: LevelData):
	level_data = data
	name_label.text = " " + data.level_name
	if data.preview_image:
		preview.texture = data.preview_image
	else:
		preview.modulate = Color(0.2, 0.2, 0.2)  # dark placeholder
	var completed = savemanager.is_completed(data.level_id)
	if completed:
		var best = savemanager.get_best_shots(data.level_id)
		shots_label.text = " Best: %d shots" % best
	else:
		shots_label.text = " Not played"
	
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("card_pressed", level_data)

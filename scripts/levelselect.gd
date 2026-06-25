extends Control

@onready var level_grid = $CanvasLayer/levelgrid
@onready var back_button = $CanvasLayer/backbutton

const LEVEL_CARD = preload("res://scenes/ui/levelcard.tscn")
const REGISTRY = preload("res://resources/levelregistry.tres")

func _ready():
	back_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/ui/mainmenu.tscn")
	)
	_load_levels()

func _load_levels():
	for data in REGISTRY.levels:
		var card = LEVEL_CARD.instantiate()
		level_grid.add_child(card)
		card.setup(data)
		card.card_pressed.connect(_on_card_pressed)

func _on_card_pressed(data: LevelData):
	if data.scene_path != "":
		get_tree().change_scene_to_file(data.scene_path)

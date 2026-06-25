extends Control

@onready var play_button = $CanvasLayer/VBoxContainer/playbutton
@onready var quit_button = $CanvasLayer/VBoxContainer/quitbutton

func _ready():
	play_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/ui/levelselect.tscn")
	)
	quit_button.pressed.connect(func():
		get_tree().quit()
	)

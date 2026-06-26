extends Control

@onready var play_button = $CanvasLayer/VBoxContainer/playbutton
@onready var quit_button = $CanvasLayer/VBoxContainer/quitbutton
@onready var options_button = $CanvasLayer/VBoxContainer/optionsbutton

func _ready():
	play_button.pressed.connect(func():
		scenetransition.go_to("res://scenes/ui/levelselect.tscn")
	)
	quit_button.pressed.connect(func():
		get_tree().quit()
	)
	options_button.pressed.connect(func():
		scenetransition.go_to("res://scenes/ui/options.tscn")
	)

extends Control

@onready var window_mode_option = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/windowmodeoption
@onready var master_slider = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer2/masterslider
@onready var master_value = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer2/mastervalue
@onready var music_slider = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer3/musicslider
@onready var music_value = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer3/musicvalue
@onready var sfx_slider = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer4/sfxslider
@onready var sfx_value = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer4/sfxvalue
@onready var back_button = $CanvasLayer/PanelContainer/VBoxContainer/backbutton

var return_scene: String = "res://scenes/ui/mainmenu.tscn"

func _ready():
	window_mode_option.add_item("Windowed", 0)
	window_mode_option.add_item("Fullscreen", 1)
	window_mode_option.selected = 1 if settingsmanager.fullscreen else 0
	window_mode_option.item_selected.connect(_on_window_mode_selected)
	master_slider.value = settingsmanager.master_volume
	music_slider.value = settingsmanager.music_volume
	sfx_slider.value = settingsmanager.sfx_volume
	master_value.text = "%d" % settingsmanager.master_volume
	music_value.text = "%d" % settingsmanager.music_volume
	sfx_value.text = "%d" % settingsmanager.sfx_volume
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	back_button.pressed.connect(func():
		scenetransition.go_to(return_scene)
	)

func _on_window_mode_selected(index: int):
	settingsmanager.set_fullscreen(index == 1)

func _on_master_changed(value: float):
	master_value.text = "%d" % value
	settingsmanager.set_master(value)

func _on_music_changed(value: float):
	music_value.text = "%d" % value
	settingsmanager.set_music(value)

func _on_sfx_changed(value: float):
	sfx_value.text = "%d" % value
	settingsmanager.set_sfx(value)

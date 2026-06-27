extends Node

const SAVE_PATH = "user://settings.cfg"
var config = ConfigFile.new()
var master_volume: float = 100.0
var music_volume: float = 100.0
var sfx_volume: float = 100.0
var fullscreen: bool = false
var options_return_scene: String = "res://scenes/ui/mainmenu.tscn"

func _ready():
	config.load(SAVE_PATH)
	master_volume = config.get_value("audio", "master", 100.0)
	music_volume = config.get_value("audio", "music", 100.0)
	sfx_volume = config.get_value("audio", "sfx", 100.0)
	fullscreen = config.get_value("display", "fullscreen", false)
	_apply_all()

func set_master(value: float):
	master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))
	_save()

func set_music(value: float):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / 100.0))
	_save()

func set_sfx(value: float):
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value / 100.0))
	_save()

func set_fullscreen(value: bool):
	fullscreen = value
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	_save()

func _apply_all():
	set_master(master_volume)
	set_music(music_volume)
	set_sfx(sfx_volume)
	set_fullscreen(fullscreen)

func _save():
	config.set_value("audio", "master", master_volume)
	config.set_value("audio", "music", music_volume)
	config.set_value("audio", "sfx", sfx_volume)
	config.set_value("display", "fullscreen", fullscreen)
	config.save(SAVE_PATH)

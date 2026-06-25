extends Node

const SAVE_PATH = "user://saves.cfg"
var config = ConfigFile.new()

func _ready():
	config.load(SAVE_PATH)

func save_level(level_id: String, shots: int, stars: int):
	var best_shots = config.get_value(level_id, "best_shots", 9999)
	var best_stars = config.get_value(level_id, "stars", 0)
	if shots < best_shots:
		config.set_value(level_id, "best_shots", shots)
	if stars > best_stars:
		config.set_value(level_id, "stars", stars)
	config.save(SAVE_PATH)

func get_stars(level_id: String) -> int:
	return config.get_value(level_id, "stars", 0)

func get_best_shots(level_id: String) -> int:
	return config.get_value(level_id, "best_shots", -1)

func is_completed(level_id: String) -> bool:
	return config.has_section(level_id)

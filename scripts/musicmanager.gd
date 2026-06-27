extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(player)
	player.bus = "Music"

func play(stream: AudioStream):
	if player.stream == stream and player.playing:
		return
	player.stream = stream
	player.play()

func stop():
	player.stop()

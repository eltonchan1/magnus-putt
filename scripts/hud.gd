extends CanvasLayer

@onready var shot_label = $shotlabel
@onready var par_label = $parlabel
@onready var retry_button = $retrybutton
@onready var options_button = $optionsbutton
@onready var levelselect_button = $levelselectbutton

signal retry_pressed
signal levelselect_pressed
signal options_pressed

func _ready():
	shot_label.text = "SHOTS: 0"
	par_label.text = "PAR: 3"
	retry_button.pressed.connect(func(): emit_signal("retry_pressed"))
	options_button.pressed.connect(func(): emit_signal("options_pressed"))
	levelselect_button.pressed.connect(func(): emit_signal("levelselect_pressed"))

func update_shots(count: int):
	shot_label.text = "SHOTS: %d" % count

func setup(par: int):
	par_label.text = "PAR: %d" % par

extends CanvasLayer

@onready var shot_label = $HBoxContainer/shotlabel
@onready var par_label = $HBoxContainer/parlabel

func _ready():
	shot_label.text = "SHOTS: 0"
	par_label.text = "  PAR: 3"

func update_shots(count: int):
	shot_label.text = "SHOTS: %d" % count

func setup(par: int):
	par_label.text = "  PAR: %d" % par

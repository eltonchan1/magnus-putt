extends RigidBody2D

var spin := Vector2.ZERO
var spin_force_duration := 0.0
var max_spin_duration := 1.5

func _ready() -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if spin_force_duration > 0:
		apply_central_force(vector) = spin * 150
		
		
		

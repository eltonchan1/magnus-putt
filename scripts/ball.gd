extends RigidBody2D

var spin := Vector2.ZERO
var spin_force_duration := 0.0
var max_spin_duration := 1.5

func _ready() -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if spin_force_duration > 0:
		apply_central_force(spin * 150)
		spin_force_duration -= get_physics_process_delta_time()

func launch(direction: Vector2, power: float, spin_input: Vector2):
	spin = spin_input
	spin_force_duration = max_spin_duration
	apply_central_impulse(direction * power)

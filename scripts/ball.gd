extends RigidBody2D

var spin: Vector2 = Vector2.ZERO
var is_moving: bool = false
var is_aiming: bool = false
var drag_start: Vector2 = Vector2.ZERO
var launch_direction: Vector2 = Vector2.ZERO
var launch_power: float = 0.0

const MAX_DRAG_DISTANCE: float = 150.0
const LAUNCH_FORCE_MULTIPLIER: float = 8.0
const SPIN_LATERAL_FORCE: float = 750.0
const SPIN_DECAY: float = 0.98
const MIN_VELOCITY_THRESHOLD: float = 15.0
const SPIN_SIDE_MULTIPLIER: float = 1.0
const SPIN_TOP_MULTIPLIER: float = 0.25 
const SPIN_BACK_MULTIPLIER: float = 7.5
signal ball_stopped
signal ball_entered_hole

func _try_start_aim(mouse_pos: Vector2):
	if is_moving:
		return
	if global_position.distance_to(mouse_pos) < 40.0:
		is_aiming = true
		drag_start = mouse_pos

func _update_aim(mouse_pos: Vector2):
	var drag_vector = mouse_pos - drag_start
	var clamped = drag_vector.limit_length(MAX_DRAG_DISTANCE)
	var launch_dir = -clamped.normalized()
	var power = clamped.length() / MAX_DRAG_DISTANCE
	_draw_aim_line(global_position, launch_dir, power)

func _release_shot(mouse_pos: Vector2):
	is_aiming = false
	var drag_vector = mouse_pos - drag_start
	var clamped = drag_vector.limit_length(MAX_DRAG_DISTANCE)
	if clamped.length() < 10.0:
		return
	var launch_dir = -clamped.normalized()
	var power = clamped.length() / MAX_DRAG_DISTANCE
	_clear_aim_line()
	launch(launch_dir, power)

var pending_launch: Vector2 = Vector2.ZERO
var locked_spin: Vector2 = Vector2.ZERO

func launch(direction: Vector2, power: float):
	pending_launch = direction * power * MAX_DRAG_DISTANCE * LAUNCH_FORCE_MULTIPLIER
	launch_direction = direction
	launch_power = power
	locked_spin = spin
	is_moving = true

var frames_since_launch: int = 0

func _physics_process(delta: float):
	if pending_launch != Vector2.ZERO:
		apply_central_impulse(pending_launch)
		pending_launch = Vector2.ZERO
	if not is_moving:
		return
	frames_since_launch += 1
	if locked_spin.length() > 0.01:
		var travel_dir = linear_velocity.normalized() if linear_velocity.length() > 1.0 else launch_direction
		var right_perp = Vector2(-travel_dir.y, travel_dir.x)
		var lateral_force = right_perp * locked_spin.x * SPIN_LATERAL_FORCE * SPIN_SIDE_MULTIPLIER * launch_power
		var vertical_spin = locked_spin.y
		var vertical_multiplier = SPIN_BACK_MULTIPLIER if vertical_spin < 0.0 else SPIN_TOP_MULTIPLIER
		var forward_force: Vector2
		if vertical_spin < 0.0:
			forward_force = -launch_direction * abs(vertical_spin) * SPIN_LATERAL_FORCE * vertical_multiplier * launch_power
		else:
			forward_force = travel_dir * vertical_spin * SPIN_LATERAL_FORCE * vertical_multiplier * launch_power
		apply_central_force(lateral_force + forward_force)
		locked_spin *= SPIN_DECAY
	if frames_since_launch > 10 and linear_velocity.length() < MIN_VELOCITY_THRESHOLD and is_moving:
		linear_velocity = Vector2.ZERO
		is_moving = false
		frames_since_launch = 0
		emit_signal("ball_stopped")

func set_spin(spin_vector: Vector2):
	spin = spin_vector.limit_length(1.0)

func reset_spin():
	spin = Vector2.ZERO

func _on_body_entered(body):
	if body.is_in_group("hole_trigger"):
		emit_signal("ball_entered_hole")

# aim line

var aim_line: Line2D = null

func _draw_aim_line(from: Vector2, direction: Vector2, power: float):
	if aim_line == null:
		aim_line = Line2D.new()
		aim_line.width = 2.0
		aim_line.default_color = Color(1,1,1,0.6)
		get_parent().add_child(aim_line)
	var line_length = power * MAX_DRAG_DISTANCE * 1.5
	aim_line.clear_points()
	aim_line.add_point(from)
	aim_line.add_point(from + direction * line_length)

func _clear_aim_line():
	if aim_line != null:
		aim_line.queue_free()
		aim_line = null

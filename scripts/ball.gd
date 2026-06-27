extends RigidBody2D

var spin: Vector2 = Vector2.ZERO
var is_moving: bool = false
var is_aiming: bool = false
var drag_start: Vector2 = Vector2.ZERO
var launch_direction: Vector2 = Vector2.ZERO
var launch_power: float = 0.0
var trail_points: Array[Vector2] = []
var trail_node: Line2D = null

const MAX_DRAG_DISTANCE: float = 150.0
const LAUNCH_FORCE_MULTIPLIER: float = 8.0
const SPIN_LATERAL_FORCE: float = 750.0
const SPIN_DECAY: float = 0.98
const MIN_VELOCITY_THRESHOLD: float = 15.0
const SPIN_SIDE_MULTIPLIER: float = 1.0
const SPIN_TOP_MULTIPLIER: float = 0.25 
const SPIN_BACK_MULTIPLIER: float = 7.5
const TRAIL_LENGTH = 20
const MIN_TRAIL_SPEED = 20.0

signal ball_stopped
signal ball_entered_hole

func _ready():
	_setup_trail.call_deferred()

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
	_update_trail()
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

var aim_line: Node2D = null

func _draw_aim_line(from: Vector2, direction: Vector2, power: float):
	if aim_line == null:
		aim_line = Node2D.new()
		get_parent().add_child(aim_line)
	for child in aim_line.get_children():
		child.queue_free()
	var line_length = power * MAX_DRAG_DISTANCE * 1.5
	var dash_length = 10.0
	var gap_length = 6.0
	var traveled = 0.0
	while traveled < line_length:
		var dash_end = min(traveled + dash_length, line_length)
		var seg = Line2D.new()
		seg.width = 5.0
		seg.default_color = Color(1, 1, 1, 0.6)
		seg.add_point(from + direction * traveled)
		seg.add_point(from + direction * dash_end)
		aim_line.add_child(seg)
		traveled += dash_length + gap_length
	if spin.length() > 0.05:
		var right_perp = Vector2(-direction.y, direction.x)
		var curve_dir = right_perp * spin.x
		if spin.y > 0.0:
			curve_dir += direction * spin.y * 0.5
		else:
			curve_dir -= direction * abs(spin.y) * 1.5
		var arrow_size = spin.length() * 40.0 * power
		var arrow_dir = curve_dir.normalized()
		var arrow_tip = from + arrow_dir * arrow_size
		var arrow_left = arrow_tip - arrow_dir.rotated(deg_to_rad(25)) * arrow_size * 0.4
		var arrow_right = arrow_tip - arrow_dir.rotated(deg_to_rad(-25)) * arrow_size * 0.4
		var arrow = Line2D.new()
		arrow.width = 2.5
		arrow.default_color = Color(1.0, 1.0, 1.0, 0.85)
		arrow.add_point(from)
		arrow.add_point(arrow_tip)
		aim_line.add_child(arrow)
		var head = Line2D.new()
		head.width = 2.5
		head.default_color = Color(1.0, 1.0, 1.0, 0.85)
		head.add_point(arrow_left)
		head.add_point(arrow_tip)
		head.add_point(arrow_right)
		aim_line.add_child(head)

func _clear_aim_line():
	if aim_line != null:
		aim_line.queue_free()
		aim_line = null

func _setup_trail():
	trail_node = Line2D.new()
	trail_node.width = 12.0
	trail_node.default_color = Color(1, 1, 1, 0.6)
	trail_node.begin_cap_mode = Line2D.LINE_CAP_ROUND
	trail_node.end_cap_mode = Line2D.LINE_CAP_ROUND
	var gradient = Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 0.0))
	gradient.set_color(1, Color(1, 1, 1, 0.5))
	trail_node.gradient = gradient
	get_parent().add_child(trail_node)

func _update_trail():
	if trail_node == null:
		return
	var speed = linear_velocity.length()
	if speed < MIN_TRAIL_SPEED or not is_moving:
		trail_points.clear()
		trail_node.clear_points()
		return
	trail_points.append(global_position)
	var dynamic_length = int(clamp(speed / 50.0, 3, TRAIL_LENGTH))
	while trail_points.size() > dynamic_length:
		trail_points.pop_front()
	trail_node.clear_points()
	for p in trail_points:
		trail_node.add_point(p)

extends Spatial

export(NodePath) var sim_node_path
onready var sim = get_node(sim_node_path)

var a = 30
var d = 5
var vy = 0
var vx = 0
var w = 0
var theta = 0
var theta_1 = 0
var theta_2 = 0
var theta_3 = 0
var theta_4 = 0
var x_1 = d
var y_1 = 0
var x_2 = 0
var y_2 = d
var x_3 = -d
var y_3 = 0
var x_4 = 0
var y_4 = -d

func _ready():
	sim.connect("apply_torque", self, "on_torque_applied")
	sim.connect("change_velocity", self, "on_velocity_changed")
	sim.connect("apply_angular_velocity", self, "on_angular_velocity_applied")
	update_wheels()

func update_wheels():
	var wheel_1 = $body/front_left_wheel
	var wheel_2 = $body/front_right_wheel
	var wheel_3 = $body/rear_left_wheel
	var wheel_4 = $body/rear_right_wheel
	
	wheel_1.translation = Vector3(x_1, 0.0, y_1)
	wheel_1.rotation = Vector3(0.0, theta_1 + PI/2.0, -PI/2.0)
	wheel_2.translation = Vector3(x_2, 0.0, y_2)
	wheel_2.rotation = Vector3(0.0, theta_2 + PI/2.0, -PI/2.0)
	wheel_3.translation = Vector3(x_3, 0.0, y_3)
	wheel_3.rotation = Vector3(0.0, theta_3 + PI/2.0, -PI/2.0)
	wheel_4.translation = Vector3(x_4, 0.0, y_4)
	wheel_4.rotation = Vector3(0.0, theta_4 + PI/2.0, -PI/2.0)

func _process(delta):
	var k = 0.002
	var dt = delta

	theta += w * dt

	# calculate linear velocity of every wheel
	var _vy = vy + d * w * cos(theta)
	var _vx = vx - d * w * sin(theta)
	theta_1 = PI / 2.0 if _vx == 0 else atan(_vy / _vx)
	
	_vy = vy - d * w * sin(theta)
	_vx = vx - d * w * cos(theta)
	theta_2 = PI / 2.0 if _vx == 0 else atan(_vy / _vx)
	
	_vy = vy - d * w * cos(theta)
	_vx = vx + d * w * sin(theta)
	theta_3 = PI / 2.0 if _vx == 0 else atan(_vy / _vx)
	
	_vy = vy + d * w * sin(theta)
	_vx = vx + d * w * cos(theta)
	theta_4 = PI / 2.0 if _vx == 0 else atan(_vy / _vx)

	var vx_1 = vx - d * w * sin(theta)
	var vy_1 = vy + d * w * cos(theta)
	var vx_2 = vx - d * w * cos(theta)
	var vy_2 = vy - d * w * sin(theta)
	var vx_3 = vx + d * w * sin(theta)
	var vy_3 = vy - d * w * cos(theta)
	var vx_4 = vx + d * w * cos(theta)
	var vy_4 = vy + d * w * sin(theta)

	x_4 += vx_4 * dt
	y_4 += vy_4 * dt
	x_1 += vx_1 * dt
	y_1 += vy_1 * dt
	x_2 += vx_2 * dt
	y_2 += vy_2 * dt
	x_3 += vx_3 * dt
	y_3 += vy_3 * dt
	
	update_wheels()

func on_torque_applied(axis, side, direction):
	var wheel
	if axis == "front":
		if side == "left":
			wheel = $body/front_left_wheel
		elif side == "right":
			wheel = $body/front_right_wheel
	elif axis == "rear":
		if side == "left":
			wheel = $body/rear_left_wheel
		elif side == "right":
			wheel = $body/rear_right_wheel

func on_velocity_changed(axis, diff):
	var delta = 1
	if diff == "minus":
		delta = -1 * delta
	
	if axis == "x-axis":
		vx += delta
	elif axis == "y-axis":
		vy += delta

func on_angular_velocity_applied(direction):
	var delta = PI / 180
	if direction == "CW":
		delta = -1 * delta
	
	w += delta

extends Camera

var mouse_position
var center_point = Vector3(0.0, 0.0, 0.0)
var camera_distanse = 10
var horizontal_angle = 0
var vertical_angle = 0

func _ready():
	pass

func enable_rotation(mouse_position):
	self.mouse_position = mouse_position

func update_rotation():
	rotate_camera(horizontal_angle, vertical_angle)

func relative_rotation(horizontal_diff, vertical_diff):
	if not mouse_position:
		return
	
	horizontal_angle += horizontal_diff
	vertical_angle = vertical_diff
	rotate_camera(horizontal_angle, vertical_angle)

func zoom_out():
	if camera_distanse < 18:
		camera_distanse += 1
	rotate_camera(horizontal_angle, vertical_angle)

func zoom_in():
	if camera_distanse > 6:
		camera_distanse -= 1
	rotate_camera(horizontal_angle, vertical_angle)

func rotate_camera(horizontal_angle, vertical_angle):
	var position = self.translation
	position.x = sin(horizontal_angle) * camera_distanse + center_point.x
	position.z = cos(horizontal_angle) * camera_distanse + center_point.z
	if (position.y < 12 && vertical_angle > 0
			|| position.y > 2 && vertical_angle < 0):
		position.y += vertical_angle
	vertical_angle = 0
	self.look_at_from_position(position, center_point, Vector3.UP)

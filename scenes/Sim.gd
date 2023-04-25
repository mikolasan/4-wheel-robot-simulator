extends Spatial

signal apply_torque
signal change_velocity
signal apply_angular_velocity

func _ready():
	$Camera.update_rotation()

func _input(event):
	if event is InputEventKey:
		if event.is_pressed():
			var code = event.get_scancode_with_modifiers()
			var pressed_name = OS.get_scancode_string(code)
			match pressed_name:
				"Space":
					# toggle pause
					pass
				"BracketLeft":
					emit_signal("apply_angular_velocity", "CCW")
				"BracketRight":
					emit_signal("apply_angular_velocity", "CW")
				"Up":
					emit_signal("change_velocity", "y-axis", "plus")
				"Down":
					emit_signal("change_velocity", "y-axis", "minus")
				"Right":
					emit_signal("change_velocity", "x-axis", "plus")
				"Left":
					emit_signal("change_velocity", "x-axis", "minus")
				"1":
					emit_signal("apply_torque", "front", "left", "forward")
				"Q":
					emit_signal("apply_torque", "front", "left", "reverse")
				"2":
					emit_signal("apply_torque", "front", "right", "forward")
				"W":
					emit_signal("apply_torque", "front", "right", "reverse")
				"A":
					emit_signal("apply_torque", "rear", "left", "forward")
				"Z":
					emit_signal("apply_torque", "rear", "left", "reverse")
				"S":
					emit_signal("apply_torque", "rear", "right", "forward")
				"X":
					emit_signal("apply_torque", "rear", "right", "reverse")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				$Camera.enable_rotation(event.position)
			else:
				$Camera.enable_rotation(null)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			$Camera.zoom_out()
		elif event.button_index == BUTTON_WHEEL_UP:
			$Camera.zoom_in()
	if event is InputEventMouseMotion:
		var horizontal_angle = deg2rad(-event.relative.x)
		var vertical_angle = deg2rad(event.relative.y)
		$Camera.relative_rotation(horizontal_angle, vertical_angle)

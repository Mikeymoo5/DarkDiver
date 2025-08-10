extends Node2D

enum input_types {
	CONTROLLER,
	KEYBOARD
}

const cursor_speed = 5

var input_method
func _ready():
	if Input.get_connected_joypads().is_empty():
		input_method = input_types.KEYBOARD
	else:
		input_method = input_types.CONTROLLER
		
	match input_method:
		input_types.KEYBOARD:
			print("KEYBOARD AND MOUSE")
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		input_types.CONTROLLER:
			print("CONTROLLER")
			self.position = get_viewport_rect().size / 2
		
func _process(delta: float) -> void:
	match input_method:
		input_types.KEYBOARD:
			self.position = get_viewport().get_mouse_position()
		input_types.CONTROLLER:
			var move_direction = Input.get_vector("cursor_left", "cursor_right", "cursor_up", "cursor_down")
			self.position += move_direction * cursor_speed
			
	

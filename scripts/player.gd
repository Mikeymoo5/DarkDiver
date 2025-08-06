extends CharacterBody2D

var max_speed: float = 100
var max_acceleration: float = 1000
var move_direction: Vector2
var acceleration: Vector2

# Node references
var foreground: TileMapLayer
func _ready():
	#foreground = $"../Map/Foreground"
	pass
	#self.velocity = Vector2(10, 0)
	#self.position = Vector2(0,0)

func _process(delta):
	#TODO: Write a better movement system - incorporate mass, ACTUAL friction, IMPORTANTLY FRICTION SHOULD BE BASED ON DELTA TIME
	var vel: Vector2 = velocity*0.9
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	acceleration = move_direction * max_acceleration * delta
	vel += acceleration
	var sign = vel.sign()
	if abs(vel.x) > max_speed: vel.x = max_speed*sign.x
	if abs(vel.y) > max_speed: vel.y = max_speed*sign.y
	#print(vel)
	velocity = vel
	
	
	
func _physics_process(delta: float):
	self.move_and_slide()
	
#	Check if the player is in a door. TODO: maybe switch to global_position?
	#var tile_coord = foreground.local_to_map(self.position)
	#var tile_data = foreground.get_cell_tile_data(tile_coord)
	#if tile_data:
		#var custom_data = tile_data.get_custom_data("door_location")

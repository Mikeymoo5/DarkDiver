extends CharacterBody2D

var max_speed: float = 5000
var max_acceleration: float = 5000
var move_direction: Vector2
var acceleration: Vector2

var player_data: PlayerData
var bullet_scene = load("res://src/Projectiles/BasicProjectile.tscn")
# Node references
var foreground: TileMapLayer

@onready var cursor = $"../../CanvasLayer/Cursor"

func _ready():
	Global.player = self

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
	
	if Input.is_action_just_pressed("cast"):
		var camera_pos = get_viewport().get_camera_2d().get_screen_center_position() - (get_viewport_rect().size / 2)
		var pos = cursor.global_position + camera_pos
		var bullet = bullet_scene.instantiate()
		var direction = self.global_position.direction_to(pos)
		#print("POS: " + str(pos) + " DIRECTION: " + str(direction))
		var bullet_velocity = direction * 100
		bullet.position = self.global_position
		bullet.look_at(pos)
		bullet.velocity = bullet_velocity
		Global.main2d.add_child(bullet)
	
func _physics_process(delta: float):
	self.move_and_slide()
	
#	Check if the player is in a door. TODO: maybe switch to global_position?
	#var tile_coord = foreground.local_to_map(self.position)
	#var tile_data = foreground.get_cell_tile_data(tile_coord)
	#if tile_data:
		#var custom_data = tile_data.get_custom_data("door_location")
func enable():
	set_process(true)
	visible = true
	
func disable():
	set_process(false)
	visible = false

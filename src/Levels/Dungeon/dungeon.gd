extends Resource

## A dungeon resource. Can be directly saved. Leave seed blank for a random seed.
class_name Dungeon

## The dungeon's seed. 
@export var seed: int
## Width and height of the dungeon in tiles
@export var dungeon_size: int
## The max amount of rooms per floor
@export var maximum_rooms: int
## The total amount of floors
@export var total_floors: int
## An array storing all of the floors
@export var floors: Array[Floor]
## Stores the dungeon parameters to be passed into a level
@export var dungeon_parameters: Dictionary
var rng := RandomNumberGenerator.new()
var room_grid_size


const pregen_floors := 10
func _init(seed := 0, dungeon_size := 1000, maximum_rooms := 100, total_floors := 100):
	rng.seed = Time.get_unix_time_from_system()
	self.seed = seed
	self.dungeon_size = dungeon_size
	self.maximum_rooms = maximum_rooms
	self.room_grid_size = dungeon_size / floor(sqrt(self.maximum_rooms)) # how wide each room generation tile is
	self.dungeon_parameters = {
		"seed": self.seed,
		"dungeon_size" : self.dungeon_size,
		"room_grid_size":  self.room_grid_size
	}
	
	if(seed==0):
		self.seed = rng.randi_range(1, 1000)
	else:
		self.seed = clampi(seed, 1, 1000)
		
	for f in pregen_floors:
		var new_floor = Floor.new(dungeon_parameters, f)
		self.floors.append(new_floor)
		
	

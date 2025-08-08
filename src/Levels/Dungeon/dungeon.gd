extends Resource

## A dungeon resource. Can be directly saved. Leave seed blank for a random seed.
class_name Dungeon

## The dungeon's seed. 
@export var seed: int
## Width and height of each floor in tiles
@export var floor_size: int
## How many rooms are on each floor
@export var rooms_per_floor: int
## The total amount of floors
@export var total_floors: int
## An array storing all of the floors
@export var floors: Array[Floor]
## Stores the dungeon parameters to be passed into a level
@export var dungeon_parameters: Dictionary
var rng := RandomNumberGenerator.new()
var room_grid_size


const pregen_floors := 10
func _init(seed := 0, max_floor_size := 1000, maximum_rooms := 100, total_floors := 100):
	rng.seed = Time.get_unix_time_from_system()
	self.seed = seed
	
	#TODO: rename tiles_per_room to tiles_per_room_grid
	self.rooms_per_floor = floor(sqrt(self.maximum_rooms)) ** 2 # Finds how many rooms can be on each floor
	self.tiles_per_room = floor(max_floor_size / sqrt(self.rooms_per_floor))
	self.floor_size = sqrt(self.rooms_per_floor) * self. tiles_per_room # Determine the actual floor size, as close as possible ot the maximum room size

	self.maximum_rooms = maximum_rooms
	self.dungeon_parameters = {
		"seed": self.seed,
		"dungeon_size" : self.dungeon_size,
		"room_grid_size":  self.room_grid_size
	}
	
	print("A new dungeon has been created.")
	print("It is " + str(dungeon_size) + "x" + str(dungeon_size) + " tiles.")
	print("It contains ")
	
	if(seed==0):
		self.seed = rng.randi_range(1, 1000)
	else:
		self.seed = clampi(seed, 1, 1000)
		
	for f in pregen_floors:
		var new_floor = Floor.new(dungeon_parameters, f)
		self.floors.append(new_floor)
		
	

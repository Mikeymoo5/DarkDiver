extends Resource

## A dungeon resource. Can be directly saved. Leave seed blank for a random seed.
class_name Dungeon

## The dungeon's seed. 
@export var seed: int

# Sizing variables
@export var rooms_per_floor: int # How many rooms are on each floor
@export var room_cell_size: int # Width and height of each room gen grid cell, in tiles
@export var floor_size: int # Width and height of each floor in tiles

@export var total_floors: int # How many total floors the dungeon will have
@export var dungeon_parameters: Dictionary # Dungeon parameters, passed into floors upon their creation

@export var floors: Array[Floor] # Stores all of the floors

var rng := RandomNumberGenerator.new()
var room_grid_size

const pregen_floors := 10

# TODO: use some sort of hashing?
func _init(seed := 0, max_floor_size := 1000, maximum_rooms := 100, total_floors := 100):
	rng.seed = Time.get_unix_time_from_system()
	self.seed = seed
	
	# Room sizing
	self.rooms_per_floor = floori(sqrt(maximum_rooms)) ** 2 # Finds how many rooms can be on each floor
	self.room_cell_size = floori(max_floor_size / sqrt(self.rooms_per_floor))
	self.floor_size = sqrt(self.rooms_per_floor) * self.room_cell_size # Determine the actual floor size, as close as possible ot the maximum room size

	self.total_floors = total_floors
	self.dungeon_parameters = {
		"seed": self.seed,
		"floor_size" : self.floor_size,
		"room_cell_size":  self.room_cell_size,
		"rooms_per_floor": self.rooms_per_floor
	}
	
	print("A new dungeon has been created.")
	print("It is " + str(floor_size) + "x" + str(floor_size) + " tiles.")
	print("Each floor contains " + str(rooms_per_floor) + " rooms.")
	print("Each room cell is " + str(room_cell_size) + "x" + str(room_cell_size) + " tiles wide.")
	if  (room_cell_size % 2) == 0:
		push_error("Room cell size is not odd!")
	if(seed==0):
		self.seed = rng.randi_range(1, 1000)
	else:
		self.seed = clampi(seed, 1, 1000)
		
	for f in pregen_floors:
		var new_floor = Floor.new(dungeon_parameters, f)
		self.floors.append(new_floor)
		
func _load_floor(floor_to_load):
	pass

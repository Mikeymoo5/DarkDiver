extends Resource

## A dungeon resource. Can be directly saved. Leave seed blank for a random seed.
class_name Dungeon

## The dungeon's seed. 
@export var dungeon_seed: int

# Sizing variables
@export var rooms_per_floor: int # How many rooms are on each floor
@export var room_cell_size: int # Width and height of each room gen grid cell, in tiles
@export var floor_size: int # Width and height of each floor in tiles

@export var total_floors: int # How many total floors the dungeon will have
@export var dungeon_parameters: Dictionary # Dungeon parameters, passed into floors upon their creation

@export var floors: Array[Floor] # Stores all of the pregen_floors

var rng := RandomNumberGenerator.new()

const pregen_floors := 3

# TODO: use some sort of hashing?
func _init(dungeon_seed := 0, max_floor_size := 500, maximum_rooms := 75, total_floors := 100):
	print("DUNGEON INIT")
	rng.seed = Time.get_unix_time_from_system()
	self.dungeon_seed = dungeon_seed
	
	# Room sizing
	self.rooms_per_floor = floori(sqrt(maximum_rooms)) ** 2 # Finds how many rooms can be on each floor
	self.room_cell_size = floori(max_floor_size / sqrt(self.rooms_per_floor))
	self.floor_size = sqrt(self.rooms_per_floor) * self.room_cell_size # Determine the actual floor size, as close as possible ot the maximum room size

	self.total_floors = total_floors
	self.dungeon_parameters = {
		"dungeon_seed": self.dungeon_seed,
		"floor_size" : self.floor_size,
		"room_cell_size":  self.room_cell_size,
		"rooms_per_floor": self.rooms_per_floor
	}
	
	#print("A new dungeon has been created.")
	#print("It is " + str(floor_size) + "x" + str(floor_size) + " tiles.")
	#print("Each floor contains " + str(rooms_per_floor) + " rooms.")
	#print("Each room cell is " + str(room_cell_size) + "x" + str(room_cell_size) + " tiles wide.")
	
	if (room_cell_size % 2) == 0:
		push_error("Room cell size is not odd!")
		
	# TODO: Better seed system
	if(dungeon_seed==0):
		self.dungeon_seed = rng.randi_range(1, 1000)
	else:
		self.dungeon_seed = clampi(dungeon_seed, 1, 1000)
		
	for f in pregen_floors:
		var new_floor:Floor = Floor.new(self.dungeon_parameters, f)
		self.floors.append(new_floor)
		#var fl:Floor = Floor.new(self.dungeon_parameters, f)
			

func get_floor_reference(floor_id):
	return self.floors[floor_id]

func _load_floor(floor_to_load):
	#TODO: Implement
	Global.level_tilemap = self.floors[floor_to_load].get_tilemaplayer()

extends Resource

## A floor of a dungeon.
class_name Floor
#@export var tiles: Array[Array[int]]
#var tiles: Array[Array[]]

@export var dungeon_seed: int
## The seed of the individual floor
@export var floor_seed: int
## Dungeon width and height, in tiles

@export var floor_size: int
## Width and height of the gridcells used to generate a dungeon floor
@export var room_cell_size: int

@export var rooms_per_floor: int
enum Tiles {
	FLOOR,
	WALL,
	DOWN_PORTAL,
	UP_PORTAL
}

func _init(dungeon_paramaters: Dictionary, floor_number) -> void:
	self.dungeon_seed = dungeon_paramaters.seed
	self.floor_size = dungeon_paramaters.floor_size
	self.room_cell_size = dungeon_paramaters.room_cell_size
	self.rooms_per_floor = dungeon_paramaters.rooms_per_floor
	
	self.floor_seed = _generate_floor_seed()
	_generate_floor()
	
#TODO: Ensure all cells always have a true center

func _generate_floor():
	var rng = RandomNumberGenerator.new()
	var sq_rooms_per_floor = sqrt(self.rooms_per_floor)
	var rooms = []
	for x in range(sq_rooms_per_floor):
		rooms.append([])
		for y in range(sq_rooms_per_floor):
			#rng.seed = floor_seed * x * y	
			#TODO: Go over this to make sure this is correct		
			var x_offset = _irng(rng).randi_range(roundi(0-((room_cell_size-1)/4)), roundi((room_cell_size-1)/4))
			var y_offset = _irng(rng).randi_range(roundi(0-((room_cell_size-1)/4)), roundi((room_cell_size-1)/4))
			#TODO: Ensure that the room has a minimum required size, but that this size is always possible, regardless of offsets
			
			var width = _irng(rng).randi_range(2, abs(((room_cell_size-1)/2) - x_offset)) * 2
			var height = _irng(rng).randi_range(2, abs(((room_cell_size-1)/2) - y_offset)) * 2
			rooms[x].append({
				"x_offset": x_offset,
				"y_offset": y_offset,
				"width": width,
				"height": height
			})
	

# Increment RNG seed every use
func _irng(rng) -> RandomNumberGenerator:
	rng.seed += 1
	return rng

func _generate_floor_seed() -> int:
	var dungeon_rng = RandomNumberGenerator.new()
	dungeon_rng.seed = dungeon_seed
	var new_seed = dungeon_rng.randi()
	return new_seed

func tiles_to_tilemap(tiles):
	pass

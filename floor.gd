extends Resource

## A floor of a dungeon.
class_name Floor

#@export var tiles: Array[Array[int]]
@export var dungeon_seed: int
## The seed of the individual floor
@export var floor_seed: int
## Dungeon width and height, in tiles

@export var dungeon_size: int
## Width and height of the gridcells used to generate a dungeon floor
@export var room_grid_size: int

func _init(dungeon_paramaters: Dictionary, floor_number) -> void:
	self.dungeon_seed = dungeon_paramaters.seed
	self.dungeon_size = dungeon_paramaters.dungeon_size
	self.room_grid_size = dungeon_paramaters.room_grid_size
	
	self.floor_seed = _generate_floor_seed()
	_generate_floor()
	
func _generate_floor():
	var floor_rng = RandomNumberGenerator.new()
	floor_rng.seed = floor_seed
	

func _generate_floor_seed() -> int:
	var dungeon_rng = RandomNumberGenerator.new()
	dungeon_rng.seed = dungeon_seed
	var new_seed = dungeon_rng.randi()
	return new_seed

func tiles_to_tilemap(tiles):
	pass

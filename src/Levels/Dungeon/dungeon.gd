extends Resource

## A dungeon resource. Can be directly saved. Leave seed blank for a random seed.
class_name Dungeon

@export var seed: int

## Width and height of the dungeon in tiles
@export var dungeon_size: int
## The max amount of rooms per floor
@export var maximum_rooms: int
## The total amount of floors
@export var total_floors: int
var rng := RandomNumberGenerator.new()

const pregen_floors := 10
func _init(seed := 0, dungeon_size := 1000, maximum_rooms := 100, total_floors := 100):
	self.dungeon_size = dungeon_size
	if(seed==0):
		self.seed = rng.randi_range(1, 1000)
	else:
		self.seed = clampi(seed, 1, 1000)
	

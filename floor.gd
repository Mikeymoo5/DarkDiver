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

# ooh spooky and dangerous!
@export var tiles = []
enum Tiles {
	FLOOR,
	WALL
}

# A spawn room serves as the up-elevator and spawnpoint when traveling down a floor
enum RoomTypes {
	SPAWN,
	BLANK,
	ENEMY,
	TREASURE,
	MINI_BOSS,
	BOSS,
}

# Measured in percentage. Set to -1 for custom logic
const RoomTypeChances = {
	RoomTypes.BLANK: 60,
	RoomTypes.ENEMY: 35,
	RoomTypes.TREASURE: 2.5,
	RoomTypes.MINI_BOSS: 2.5,
	RoomTypes.SPAWN: -1, # One per floor
	RoomTypes.BOSS: -1, # One per floor
}

func _init(dungeon_paramaters := {
	"dungeon_seed": 1,
	"floor_size": 999,
	"room_cell_size": 111,
	"rooms_per_floor": 81
}, floor_number := 100) -> void:
	self.dungeon_seed = dungeon_paramaters.dungeon_seed
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
	for x in range(floor_size):
		tiles.append([])
		for y in range(floor_size):
			tiles[x].append(Tiles.WALL)
			#tiles[x][y] = Tiles.WALL
			
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
			
			#TODO: Implement room types
			rooms[x].append({
				"x_offset": x_offset,
				"y_offset": y_offset,
				"width": width,
				"height": height
			})

	for i in range(rooms.size()):
		for j in range(rooms[i].size()):
			var center_tile = Vector2((i*room_cell_size) + i, (j*room_cell_size) + j)
			#TODO: Check to see if rooms[i][j] is correct or if its the other way around
			var offset_center = Vector2(center_tile.x + rooms[i][j].x_offset, center_tile.y + rooms[i][j].y_offset)
			var topleft_tile = Vector2(offset_center.x - (rooms[i][j].width/2), offset_center.y - (rooms[i][j].height/2))
			var local_tiles = []
			
			for x in range(rooms[i][j].width):
				#local_tiles.append([])
				for y in range(rooms[i][j].height):
					# Get the real location of each local tile, and set it to a floor
					var real_location = Vector2(topleft_tile.x + x, topleft_tile.y + y)
					tiles[real_location.x][real_location.y] = Tiles.FLOOR
					#local_tiles[x].append(
						#Tiles.FLOOR
					#)
# Increment RNG seed every use
func _irng(rng) -> RandomNumberGenerator:
	rng.seed += 1
	return rng

func _generate_floor_seed() -> int:
	# TODO: Incorporate floor #. Currently, every floor uses the same seed
	var dungeon_rng = RandomNumberGenerator.new()
	dungeon_rng.seed = dungeon_seed
	var new_seed = dungeon_rng.randi()
	return new_seed

func get_tilemaplayer() -> TileMapLayer:
	var tileset: TileSet = preload("res://assets/tilesets/dungeon_tileset.tres")
	var layer = TileMapLayer.new()
	for x in range(tiles.size()):
		for y in range(tiles[x].size()):
			if tiles[x][y] == Tiles.WALL:
				layer.set_cell(Vector2(x, y), 1, Vector2(2,1))
			else:
				layer.set_cell(Vector2(x, y), 1, Vector2(0,0))
	return layer

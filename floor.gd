extends Resource

## A floor of a dungeon.
class_name Floor
#@export var tiles: Array[Array[int]]
#var tiles: Array[Array[]]
var tileset: TileSet = load("res://assets/tilesets/custom_tileset.tres")
@export var dungeon_seed: int
## The seed of the individual floor
@export var floor_seed: int
## Dungeon width and height, in tiles

@export var floor_size: int
## Width and height of the gridcells used to generate a dungeon floor
@export var room_cell_size: int

@export var rooms_per_floor: int

@export var rooms = []

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
	#var rooms = []
	
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
			var width = _irng(rng).randi_range(5, abs(((room_cell_size-1)/2) - x_offset)) * 2
			var height = _irng(rng).randi_range(5, abs(((room_cell_size-1)/2) - y_offset)) * 2
			
			#TODO: Implement room types
			rooms[x].append({
				"x_offset": x_offset,
				"y_offset": y_offset,
				"width": width,
				"height": height
			})
	
	var flattened_rooms = []
	
	for i in range(rooms.size()):
		for j in range(rooms[i].size()):
			var center_tile = Vector2((i*room_cell_size) + i, (j*room_cell_size) + j)
			#TODO: Check to see if rooms[i][j] is correct or if its the other way around
			var offset_center = Vector2(center_tile.x + rooms[i][j].x_offset, center_tile.y + rooms[i][j].y_offset)
			var topleft_tile = Vector2(offset_center.x - (rooms[i][j].width/2), offset_center.y - (rooms[i][j].height/2))
			var local_tiles = []
			rooms[i][j].offset_center = offset_center
			#TODO: Find a better spot for this segment
			# Add this room to the flattened_rooms list
			flattened_rooms.append(rooms[i][j])
			
			for x in range(rooms[i][j].width):
				#local_tiles.append([])
				for y in range(rooms[i][j].height):
					# Get the real location of each local tile, and set it to a floor
					var real_location = Vector2(topleft_tile.x + x, topleft_tile.y + y)
					tiles[real_location.x][real_location.y] = Tiles.FLOOR
					#local_tiles[x].append(
						#Tiles.FLOOR
					#)
					
	# Generate tunnels
	flattened_rooms.shuffle()
	for i in flattened_rooms.size():
		var first_center = flattened_rooms[i].offset_center
		var next_center = flattened_rooms[mini(i+1, flattened_rooms.size()-1)].offset_center
		var x_avg = ceili((first_center.x + next_center.y) / 2)
		var y_avg = ceili((first_center.y + next_center.y) / 2)
		#if _irng(rng).randi_range(0,1) == 0:
		if false:
			# Vertical then horizontal
			_create_v_tunnel(first_center.y, y_avg, first_center.x)
			_create_h_tunnel(first_center.x, next_center.x, y_avg)
			_create_v_tunnel(y_avg, next_center.y, next_center.x)
		else:
			# Horizontal then vertical
			_create_h_tunnel(first_center.x, x_avg, first_center.y)
			_create_v_tunnel(first_center.y, next_center.y, x_avg)
			_create_h_tunnel(x_avg, next_center.x, next_center.y)
			
func _create_h_tunnel(x1, x2, y):
	for x in range(min(x1, x2), max(x1, x2) + 1):
		tiles[x][y] = Tiles.FLOOR
		tiles[x][y+1] = Tiles.FLOOR
	
func _create_v_tunnel(y1, y2, x):
	for y in range(min(y1, y2), max(y1, y2) + 1):
		tiles[x][y] = Tiles.FLOOR
		tiles[x+1][y] = Tiles.FLOOR
	
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
	print("Getting tilemaplayer")
	var layer = TileMapLayer.new()
	layer.tile_set = tileset
	#var walls = []
	var floors = []
	for x in range(tiles.size()):
		for y in range(tiles[x].size()):
			if tiles[x][y] == Tiles.WALL:
				layer.set_cell(Vector2(x, y), 0, Vector2(0,5))
				#layer.set_cells_terrain_connect()
			else:
				floors.append(Vector2(x,y))
				#layer.set_cell(Vector2(x, y), 0, Vector2(0,0))
	layer.set_cells_terrain_connect(floors, 0, 0)
	return layer

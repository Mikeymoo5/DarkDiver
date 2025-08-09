extends Resource
## A save-game object. Stores the game-state of all relevant objects
class_name SavedGame

@export var player_data: PlayerData
@export var dungeon: Dungeon

func _init(
			player_data := PlayerData.new(),
			dungeon := Dungeon.new(0, 1001, 101, 100)
		):
	self.player_data = player_data
	self.dungeon = dungeon
	

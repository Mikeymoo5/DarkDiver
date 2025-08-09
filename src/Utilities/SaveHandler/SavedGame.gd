extends Resource
## A save-game object. Stores the game-state of all relevant objects
class_name SavedGame

@export var player_data: PlayerData
@export var dungeon: Dungeon

#TODO: Store only the data required to reconstruct a Dungeon in the save file. This avoids Dungeon double initializing
func _init(
			player_data := PlayerData.new(),
			dungeon := Dungeon.new()
		):
	self.player_data = player_data
	self.dungeon = dungeon
	

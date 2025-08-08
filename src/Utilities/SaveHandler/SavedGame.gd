extends Resource
## A save-game object. Stores the game-state of all relevant objects
class_name SavedGame

@export var player_data: PlayerData

func _init(player_data := PlayerData.new()):
	self.player_data = player_data

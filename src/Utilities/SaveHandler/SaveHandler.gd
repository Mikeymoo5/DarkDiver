class_name SaveManager
extends Node

@export var save_path: String

func write_save():	
	var save_state: SavedGame = SavedGame.new()
	
	save_state.player_data = Global.player.player_data
	save_state.dungeon = Global.dungeon
	
	ResourceSaver.save(save_state, save_path)
	pass
	
func read_save():
	var save_state:SavedGame = load(save_path)
	if(!save_state):
		# Handle error
		pass
	else:
		#TODO: make persistent_player_data and player_data
		Global.player.player_data = save_state.player_data	
		Global.dungeon = save_state.dungeon
		print("max_health: %s" % save_state.player_data.max_health)
		
func new_save():
	var save_state: SavedGame = SavedGame.new()
	ResourceSaver.save(save_state, save_path)
	

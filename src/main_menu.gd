extends Control

func _on_load_game_button_pressed() -> void:
	self.visible = false
	Global.main_scene.load_game()
	
func _on_new_game_button_pressed() -> void:
	self.visible = false
	Global.main_scene.new_game()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

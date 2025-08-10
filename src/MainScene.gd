extends Node2D

#@onready var hud: CanvasLayer = $Hud
@onready var player: CharacterBody2D  = $Main2D/Player
@onready var main_2d: Node2D = $Main2D
const save_handler_script = preload("res://src/Utilities/SaveHandler/SaveHandler.gd")
@onready var save_handler: save_handler_script = $Utilities/SaveHandler
#@onready var SaveHandler: Node = $Utilities/SaveHandler

var level_instance: Node2D

func _ready():
	Global.main_scene = self
	player.disable()

func load_game():
	save_handler.read_save()
	#load_level("dungeon")
	Global.dungeon._load_floor(0)
	$Main2D.add_child(Global.level_tilemap)
	player.position = Global.dungeon.get_floor_reference(0).get_player_spawn(Global.level_tilemap)
	print(Global.dungeon.get_floor_reference(0).get_player_spawn(Global.level_tilemap))
	player.enable()
	
func new_game():
	save_handler.new_save()
	load_game()

func unload_level():
	if(is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null
	
func load_level(level_name):
	unload_level()
	var level_path: String = "res://src/Levels/%s.tscn" % level_name
	var packed_level: PackedScene = load(level_path)
	if(is_instance_valid(packed_level)):
		level_instance = packed_level.instantiate()
		main_2d.add_child(level_instance)
		level_instance.z_index = 0
	

extends Node2D

#@onready var hud: CanvasLayer = $Hud
@onready var player: CharacterBody2D  = $Main2D/Player
@onready var main_2d: Node2D = $Main2D
const save_handler_script = preload("res://src/Utilities/SaveHandler/SaveHandler.gd")
@onready var save_handler: save_handler_script = $Utilities/SaveHandler
#@onready var SaveHandler: Node = $Utilities/SaveHandler

var level_instance: Node2D
var in_level: bool = false
func _ready():
	Global.main2d = self.main_2d
	Global.main_scene = self
	Global.current_floor_id = 0
	#Global.load_floor = self.load_floor
	player.disable()
	in_level = false

func load_game():
	save_handler.read_save()
	#load_level("dungeon")
	await load_floor(Global.current_floor_id)

	#print(Global.enemies)
func _process(delta: float) -> void:
	if Global.bosses.is_empty():
		if self.in_level:
			print("EMPTY")
			Global.current_floor_id += 1
			await load_floor(Global.current_floor_id)
	#pass
		

func load_floor(floor_id):
	self.in_level = false
	
	player.disable()
	
	if is_instance_valid(Global.level_tilemap):
		Global.level_tilemap.queue_free()
	Global.level_tilemap = null
	
	for i in Global.enemies:
		if is_instance_valid(i):
			i.queue_free()
	for i in Global.bosses:
		if is_instance_valid(i):
			i.queue_free()
		
	Global.current_floor = Global.dungeon.get_floor_reference(floor_id)
	Global.level_tilemap = Global.current_floor.get_tilemaplayer()
	$Main2D.add_child(Global.level_tilemap)
	Global.current_floor.spawn_enemies(Global.level_tilemap)

	player.position = Global.current_floor.get_player_spawn(Global.level_tilemap)
	player.enable()
	await wait_for_navmesh_ready()
	
	for e in Global.enemies:
		$Main2D.add_child(e)
	for e in Global.bosses:
		$Main2D.add_child(e)
	
	self.in_level = true
	
func wait_for_navmesh_ready() -> void:
	while NavigationServer2D.get_maps().is_empty():
		await get_tree().process_frame
	var nav_map = NavigationServer2D.get_maps()[0]
	while NavigationServer2D.map_get_regions(nav_map).size() == 0:
		await get_tree().process_frame
	print("Navmesh ready")
	
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
	

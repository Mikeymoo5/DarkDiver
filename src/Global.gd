extends Node

const player_script = preload("res://src/Player/player.gd")

var main_scene
var main2d
var player: player_script

var dungeon: Dungeon

var current_floor: Floor
var current_floor_id: int

var level_tilemap: TileMapLayer

var enemies: Array[Node2D]
var bosses: Array[Node2D]

#var world_gen_progress: int = 0

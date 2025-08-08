extends Area2D

var sprite: Sprite2D
var collision: CollisionShape2D
@export var tileset: TileSet

#preload TODO: figure out what this does

func _ready():
	sprite = $Sprite
	collision = $Collision
	var tileset_source: TileSetSource = tileset.get_source(0)
	print(tileset.get_source_count())

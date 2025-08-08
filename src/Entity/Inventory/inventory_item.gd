extends Resource

## The base class for an inventory item.
class_name Inventory_Item

@export var texture: Texture2D
@export var name: String


func _init(p_texture = null, p_name = "Empty Item") -> void:
	texture = p_texture
	name = p_name

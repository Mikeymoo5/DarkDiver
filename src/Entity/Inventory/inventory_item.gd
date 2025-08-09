extends Resource

## The base class for an inventory item.
class_name Inventory_Item

@export var texture: Texture2D
@export var name: String


func _init(p_texture := PlaceholderTexture2D.new(), p_name := "Empty Item") -> void:
	self.texture = p_texture
	self.name = p_name

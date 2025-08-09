extends Resource

## Contains a list of items
class_name Inventory

@export var inventory: Array[Inventory_Item]

func _init(p_inventory := [Inventory_Item.new()]) -> void:
	# TODO: figure out whats wrong with p_inventory
#	inventory = p_inventory
	inventory = [Inventory_Item.new()]

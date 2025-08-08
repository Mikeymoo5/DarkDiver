extends Resource

## Contains a list of items
class_name Inventory

@export var inventory: Array[Inventory_Item]

func _init(p_inventory: Array[Inventory_Item] = []) -> void:
	inventory = p_inventory

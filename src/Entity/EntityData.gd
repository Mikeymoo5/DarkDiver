extends Resource

## Stores all possible stats that an entity can have. 
class_name EntityData
@export var max_health: float
@export var max_mana: float
@export var inventory: Inventory

func _init(max_health := 100, max_mana := 100, inventory := Inventory.new()) -> void:
	self.max_health = max_health
	self.max_mana = max_mana
	self.inventory = inventory

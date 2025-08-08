extends EntityData
## Extends EntityData.
## Contains extra data specific to the player
class_name PlayerData

@export var money: float

func _init(money := 100):
	super()
	self.money = money

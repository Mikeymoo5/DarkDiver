extends Camera2D

@export var tracked_sprite: Sprite2D

func _ready():
	self.global_position = tracked_sprite.global_position
	var texture = tracked_sprite.texture
	var width = texture.get_width() * tracked_sprite.scale.x
	var height = texture.get_height() * tracked_sprite.scale.y

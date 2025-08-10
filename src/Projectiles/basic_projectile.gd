extends Area2D
var entity = preload("res://src/Entity/BasicEntity/entity.gd")
var boss = preload("res://src/Entity/Boss/boss.gd")
var velocity: Vector2
func _process(delta: float) -> void:
	translate(velocity * delta)
	
func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, TileMapLayer): 
		queue_free()
	if is_instance_of(body, entity):
		body.damage(50)
		queue_free()
	if is_instance_of(body, boss):
		body.damage(34)
		queue_free()

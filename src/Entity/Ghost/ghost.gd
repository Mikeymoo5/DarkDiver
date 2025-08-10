extends RigidBody2D

var enabled: bool

func _ready():
	enabled = false
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enabled = true

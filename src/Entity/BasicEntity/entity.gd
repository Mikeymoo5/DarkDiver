extends CharacterBody2D

const speed = 20

@export var player: Node2D
@export var data: EntityData
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var enabled := false
func _ready() -> void:
	self.data = EntityData.new()
	enabled = false
	$Timer.timeout.connect(make_path)
	$Timer.start(0.5)
	
func _physics_process(delta: float) -> void:
	if self.enabled:
		if nav_agent.is_navigation_finished():
			return
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()

func damage(raw_damage):
	self.data.health -= raw_damage
	if self.data.health <= 0:
		queue_free()

func make_path() -> void:
	if self.enabled:
		nav_agent.target_position = player.global_position
		#print("Agent map:", nav_agent.get_navigation_map())
		#print("Server maps:", NavigationServer2D.get_maps())

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.enabled = true

extends Node
class_name HealthComponent

@export var max_health: int = 100

var parent: CharacterBody2D
var game_manager: GameManager

# Health parameter, clamped
var health: int:
	set(value):
		health = clamp(value, 0, max_health)

# Percentage value of the health parameter
var health_pct: int:
	get:
		return health * 100 / max_health
		
# Boolean values
var can_be_damaged: bool = true

# Function for taking damage
func set_damage_taken(damage):
	health -= damage
	if health == 0:
		if parent is Player:
			get_tree().reload_current_scene()
		if parent is Enemy:
			game_manager.add_enemy(parent)
			game_manager.add_coin()
		parent.queue_free()

# Initialising health and fetching the game manager
func _ready():
	health = max_health
	game_manager = get_tree().get_first_node_in_group("GameManager")
	parent = get_parent()

extends Node
class_name HealthComponent

@export var max_health: int = 100

# Health parameter, clamped
var health: int:
	set(value):
		health = clamp(value, 0, max_health)

# Percentage value of the health parameter
var health_pct: int:
	get:
		return health * 100 / max_health

# Function for taking damage
func set_damage_taken(damage):
	health -= damage
	if health == 0:
		get_parent().queue_free()

# Initialising health
func _ready():
	health = max_health

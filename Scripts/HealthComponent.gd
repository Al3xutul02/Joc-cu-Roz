extends Node

@export var max_health: int = 100

var health: int:
	set(value):
		health = clamp(value, 0, max_health)
		
func set_damage_taken(damage):
	health -= damage
	
func _ready():
	health = max_health

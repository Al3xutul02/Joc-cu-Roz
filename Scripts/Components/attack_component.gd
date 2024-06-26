extends ShapeCast2D
class_name AttackComponent

# Attack parameters
@export var damage: int = 30
@export var attack_duration_time: float = 0.15
@export var attack_cooldown_time: float = 0.30

@onready var attack_duration = $AttackDuration
@onready var attack_cooldown = $AttackCooldown

var can_attack: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_duration.wait_time = attack_duration_time
	attack_cooldown.wait_time = attack_cooldown_time
	can_attack = true

# Called when the attack is finished
func _on_attack_duration_timeout():
	# Check for collision
	if is_colliding():
		# Check for every collision
		for iterator in get_collision_count():
			var enemy = get_collider(iterator)
			# Verify if it's an enemy
			if enemy is Enemy:
				enemy.health_component.set_damage_taken(damage)

	# Disable the component
	enabled = false
	visible = false

# Enable attacking
func _on_attack_cooldown_timeout():
	can_attack = true

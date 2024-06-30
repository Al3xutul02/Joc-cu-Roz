extends ShapeCast2D
class_name AttackComponent

# Attack parameters
@export var damage: int = 30
@export var attack_duration_time: float = 0.15
@export var attack_cooldown_time: float = 0.30
@export var attack_knockback_force: Vector2 = Vector2(100.0, -300.0)
@export var knockback_duration_time: float = 0.75
@export var attack_direction: float:
	set(value):
		attack_direction = clamp(value, -1, 1)

@onready var attack_duration: Timer = $AttackDuration
@onready var attack_cooldown: Timer = $AttackCooldown

var parent_node: Node2D

var can_attack: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_duration.wait_time = attack_duration_time
	attack_cooldown.wait_time = attack_cooldown_time
	parent_node = get_parent()
	can_attack = true

# Called when the attack is finished
func _on_attack_duration_timeout():
	# Check for collision
	if is_colliding():
		# Check for every collision
		for iterator in get_collision_count():
			var enemy = get_collider(iterator)
			# Verify if it's an enemy
			if enemy is Enemy or enemy is Player:
				attack_direction = position.x - parent_node.position.x
				enemy.hitbox_component.apply_knockback(attack_knockback_force, attack_direction, knockback_duration_time)
				enemy.hitbox_component.apply_damage(damage)

	# Disable the component
	enabled = false
	visible = false

# Enable attacking
func _on_attack_cooldown_timeout():
	can_attack = true

extends StaticBody2D

@onready var shape_cast_2d = $ShapeCast2D

# Attack parameters
@export var damage: int = 10
@export var attack_knockback_force: Vector2 = Vector2(100.0, -600.0)
@export var knockback_duration_time: float = 0.75
@export var attack_direction: float:
	set(value):
		attack_direction = clamp(value, -1, 1)

var current_enemy: Player = null
var damage_count: int = 0
var damage_interval: float = 1.0 # Interval in seconds
var time_since_last_damage: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_damage += delta
	
	if shape_cast_2d.is_colliding():
		# Check for every collision
		for iterator in shape_cast_2d.get_collision_count():
			var enemy = shape_cast_2d.get_collider(iterator)
			# Verify if it's a player
			if enemy is Player:
				attack_direction = enemy.position.x - position.x
				enemy.hitbox_component.apply_knockback(attack_knockback_force, attack_direction, knockback_duration_time)
				start_damage_sequence(enemy)
				
	if current_enemy and damage_count < 4:
		if time_since_last_damage >= damage_interval:
			current_enemy.hitbox_component.apply_damage(damage)
			damage_count += 1
			time_since_last_damage = 0.0
	elif damage_count >= 4:
		reset_damage_sequence()

func start_damage_sequence(enemy):
	current_enemy = enemy
	damage_count = 0
	time_since_last_damage = 0.0
	# Apply initial damage
	current_enemy.hitbox_component.apply_damage(damage)
	damage_count += 1

func reset_damage_sequence():
	current_enemy = null
	damage_count = 0
	time_since_last_damage = 0.0

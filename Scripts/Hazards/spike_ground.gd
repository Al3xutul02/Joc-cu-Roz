extends StaticBody2D

@onready var shape_cast_2d = $ShapeCast2D
var count: int = 0

# Attack parameters
@export var damage: int = 30
@export var attack_knockback_force: Vector2 = Vector2(100.0, -600.0)
@export var knockback_duration_time: float = 0.75
@export var attack_direction: float:
	set(value):
		attack_direction = clamp(value, -1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if shape_cast_2d.is_colliding():
		# Check for every collision
		for iterator in shape_cast_2d.get_collision_count():
			var enemy = shape_cast_2d.get_collider(iterator)
			# Verify if it's a player
			if enemy is Player:
				attack_direction = enemy.position.x - position.x
				enemy.hitbox_component.apply_knockback(attack_knockback_force, attack_direction, knockback_duration_time)
				enemy.hitbox_component.apply_damage(damage)

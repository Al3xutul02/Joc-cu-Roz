extends StaticBody2D
class_name Projectile

# Exported Variables
@export var damage: int = 30
@export var attack_knockback_force: Vector2 = Vector2(200, -300)
@export var knockback_duration_time: float = 0.75

# Imported variables
@onready var attack_shape = $AttackShape

var attack_direction: float
var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Check for collision
	if attack_shape.is_colliding():
		# Check for every collision
		for iterator in attack_shape.get_collision_count():
			var enemy = attack_shape.get_collider(iterator)
			# Verify if it's an enemy
			if enemy is Enemy or enemy is Player:
				attack_direction = enemy.position.x - position.x
				if attack_direction:
					attack_direction = attack_direction / abs(attack_direction)
				enemy.hitbox_component.apply_knockback(attack_knockback_force, attack_direction, knockback_duration_time)
				enemy.hitbox_component.apply_damage(damage)
			if enemy is Player and !enemy.is_dashing:
				queue_free()
			if enemy is StaticBody2D:
				queue_free()
	
	#Update position
	position += velocity * delta

extends Node2D
class_name Dagger

# Attack parameters
@export_group("Attack Parameters")
@export var damage: int = 20
@export var attack_duration_time: float = 0.02
@export var attack_cooldown_time: float = 0.2
@export var attack_knockback_force: Vector2 = Vector2(700.0, -200.0)
@export var knockback_duration_time: float = 0.1

# Attack hitbox parameters
@export_group("Attack Hitbox Parameters")
@export var attack_position: Vector2 = Vector2(80, 0)
@export var attack_size: Vector2 = Vector2(100, 70)

var player: Player
var attack_component: AttackComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get player node
	player = get_parent()
	for child in player.get_children():
		if child is AttackComponent:
			attack_component = child
	
	# Set parameters for the attack component
	attack_component.damage = damage
	attack_component.attack_duration.wait_time = attack_duration_time
	attack_component.attack_cooldown.wait_time = attack_cooldown_time
	attack_component.attack_knockback_force = attack_knockback_force
	attack_component.knockback_duration_time = knockback_duration_time
	
	# Set the shape of the attack
	attack_component.position = attack_position
	var attack_shape: RectangleShape2D = RectangleShape2D.new()
	attack_shape.size = attack_size
	attack_component.shape = attack_shape
	
	# Set the sprite size according to the attack size
	var sprite_width: int = 128
	var sprite_height: int = 128
	
	attack_component.sprite_2d.scale.x = attack_size.x / sprite_width
	attack_component.sprite_2d.scale.y = attack_size.y / sprite_height

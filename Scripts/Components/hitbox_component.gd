extends CollisionShape2D
class_name HitboxComponent

# Export variables
@export var stagger_duration_time: float = 0.5

# Timers
@onready var knockback_duration: Timer = $KnockbackDuration
@onready var stagger_duration: Timer = $StaggerDuration

# Nodes needed to interact with
var parent_node: CharacterBody2D
var health_component: HealthComponent

var is_staggered: bool

# Apply knockback from an attack
func apply_knockback(knockback: Vector2, direction: float, duration: float):
	# Check if the target can be damaged
	if health_component.can_be_damaged:
		parent_node.velocity.x = knockback.x * direction
		parent_node.velocity.y = knockback.y
		knockback_duration.wait_time = duration
		knockback_duration.start()
	# Handle staggers
	is_staggered = true
	stagger_duration.start()

#Apply damage from an attack
func apply_damage(damage: int):
	# Check if the target can be damaged
	if health_component.can_be_damaged:
		health_component.set_damage_taken(damage)
		#Modify the health bar depending on the target
		if parent_node is Enemy:
			parent_node.health_bar.value = health_component.health_pct
			parent_node.health_bar.visible = true
		if parent_node is Player:
			parent_node.user_interface.health_bar.value = health_component.health_pct
			health_component.can_be_damaged = false

func _ready():
	# Get the parent
	parent_node = get_parent()
	# Search for components in parent node
	var children_array: Array[Node] = parent_node.get_children()
	for child_index in parent_node.get_child_count():
		if children_array[child_index] is HealthComponent:
			health_component = children_array[child_index]
	
	# Fix the stagger duration
	stagger_duration.wait_time = stagger_duration_time
	
	is_staggered = false

# Stop horizontal movement at the end of the knockback
func _on_knockback_duration_timeout():
	parent_node.velocity.x = 0


func _on_stagger_duration_timeout():
	health_component.can_be_damaged = true
	is_staggered = false

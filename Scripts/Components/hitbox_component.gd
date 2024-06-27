extends CollisionShape2D
class_name HitboxComponent

# Components needed to interact with
var parent_node: PhysicsBody2D
var health_component: HealthComponent

# Apply knockback from an attack
func apply_knockback(knockback: Vector2, direction: float):
	if parent_node is Enemy:
		parent_node.linear_velocity = Vector2(knockback.x * direction, knockback.y)
	if parent_node is CharacterBody2D:
		parent_node.velocity.x = knockback.x * direction
		parent_node.velocity.y = knockback.y

#Apply damage from an attack
func apply_damage(damage: int):
	health_component.set_damage_taken(damage)

func _ready():
	# Search for components in parent node
	var children_array: Array[Node] = get_parent().get_children()
	for child_index in get_parent().get_child_count():
		if children_array[child_index] is HealthComponent:
			health_component = children_array[child_index]
	# Get the parent
	parent_node = get_parent()

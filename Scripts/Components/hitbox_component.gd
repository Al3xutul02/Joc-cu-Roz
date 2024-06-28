extends CollisionShape2D
class_name HitboxComponent

# Components needed to interact with
var parent_node: PhysicsBody2D
var health_component: HealthComponent

# Apply knockback from an attack
func apply_knockback(knockback: Vector2, direction: float):
	# Check if the target can be damaged
	if health_component.can_be_damaged:
		# Check for the type of target
		if parent_node is Enemy:
			parent_node.linear_velocity = Vector2(knockback.x * direction, knockback.y)
		if parent_node is Player:
			parent_node.velocity.x = knockback.x * direction
			parent_node.velocity.y = knockback.y

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

func _ready():
	# Get the parent
	parent_node = get_parent()
	# Search for components in parent node
	var children_array: Array[Node] = parent_node.get_children()
	for child_index in parent_node.get_child_count():
		if children_array[child_index] is HealthComponent:
			health_component = children_array[child_index]

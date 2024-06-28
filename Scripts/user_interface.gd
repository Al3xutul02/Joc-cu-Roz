extends CanvasLayer
class_name UserInterface

var level_node: Node2D
var player_health_component: HealthComponent

@onready var health_bar = $HealthBar


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the parent
	level_node = get_parent()
	# Search for components in parent node
	var children_array: Array[Node] = level_node.get_children()
	for child_index in level_node.get_child_count():
		if children_array[child_index] is Player:
			player_health_component = children_array[child_index].health_component
	
	# Set the HP of the health bar
	health_bar.value = player_health_component.health_pct

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

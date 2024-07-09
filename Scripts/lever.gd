extends StaticBody2D
class_name Lever

# Nodes needed to interact with
var game_manager: GameManager

var is_opened: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_tree().get_first_node_in_group("GameManager")
	is_opened = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

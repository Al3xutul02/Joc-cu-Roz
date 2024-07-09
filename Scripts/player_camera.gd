extends Camera2D

# Game manager node
var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_tree().get_first_node_in_group("GameManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position = game_manager.player.position

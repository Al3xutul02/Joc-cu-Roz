extends Node2D
class_name Key

# Exported variables
@export var key_color: GameManager.Key_Color = GameManager.Key_Color.Blue

# Imported Variables
@onready var player_detector = $PlayerDetector

# Nodes needed to interact with
var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_tree().get_first_node_in_group("GameManager")
	
	# Set modulate color
	if key_color == GameManager.Key_Color.Blue:
		modulate = Color.BLUE
	elif key_color == GameManager.Key_Color.Red:
		modulate = Color.RED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# Check for collision
	if player_detector.is_colliding():
		# Check for every collision
		for iterator in player_detector.get_collision_count():
			var collider = player_detector.get_collider(iterator)
			# Verify if it's an enemy
			if collider is Player:
				game_manager.add_key(key_color)
				queue_free()

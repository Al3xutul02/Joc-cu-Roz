extends StaticBody2D
class_name KeyDoor

# Exported variables
@export var door_color: GameManager.Key_Color = GameManager.Key_Color.Blue
@export var open_time_duration: float = 1.0
@export var open_speed: float = 250.0

# Imported variables
@onready var open_time = $OpenTime

# Nodes needed to interact with
var game_manager: GameManager
var player: Player

var is_opened: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_tree().get_first_node_in_group("GameManager")
	player = get_tree().get_first_node_in_group("Player")
	is_opened = false
	open_time.wait_time = open_time_duration
	
	# Set modulate color
	if door_color == GameManager.Key_Color.Blue:
		modulate = Color.BLUE
	elif door_color == GameManager.Key_Color.Red:
		modulate = Color.RED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# Calculate distance from player
	var distance = (player.position - position).length()
	
	# Check if player is close
	if distance < 200 and !is_opened:
		# Check for correct key and open the door
		for key in game_manager.keys_collected:
			if key == door_color:
				is_opened = true
				open_time.start()
	
	# If is opened, move the door
	if is_opened:
		position.y += open_speed * _delta


func _on_open_time_timeout():
	queue_free()

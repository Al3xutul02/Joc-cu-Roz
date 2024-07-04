extends State

# Exported variables
@export_category("Movement Parameters")
@export var idle_movement_speed: float = 100.0
@export var minimum_distance: float = -100.0
@export var maximum_distance: float = 100.0
@export var distance_from_player: float = 250.0
@export_category("Time Parameters")
@export var wander_time_duration: float = 1.0
@export var idle_time_duration: float = 1.0

# Imported variables
@onready var wander_time = $WanderTime
@onready var idle_time = $IdleTime

# Nodes needed to interact with
var player: Player
var state_machine: StateMachine
var initial_idle_position: float = 0

# Calculate all necessary parameters
func randomize_parameters():
	# Randomize direction
	var new_direction: int = randi_range(-1, 1)
	while new_direction == 0:
		new_direction = randi_range(-1, 1)
	state_machine.parent_node.direction = new_direction
	
	# Calculate current position and distance about to be walked
	var current_idle_position = state_machine.parent_node.position.x - initial_idle_position
	var distance_to_wander = idle_movement_speed * wander_time_duration * new_direction
	
	# If it would go out of bounds then change direction
	if current_idle_position + distance_to_wander < minimum_distance:
		state_machine.parent_node.direction = 1
	elif current_idle_position + distance_to_wander > maximum_distance:
		state_machine.parent_node.direction = -1

func Enter():
	# Get state macine parent, player and start the idle timer
	player = get_tree().get_first_node_in_group("Player")
	state_machine = get_parent()
	initial_idle_position = state_machine.get_parent().position.x
	wander_time.wait_time = wander_time_duration
	idle_time.wait_time = idle_time_duration
	state_machine.parent_node.velocity.x = 0
	idle_time.start()

func Physics_Update(_delta: float):
	# Calculate distance
	var distance: float = player.position.x - state_machine.parent_node.position.x
	
	# If player gets close, start following
	if abs(distance) < distance_from_player:
		Transitioned.emit(self, "EnemyFollow")

# Stop the timers
func Exit():
	wander_time.stop()
	idle_time.stop()

# Modify the velocity according to the randomized parameters
func _on_idle_time_timeout():
	randomize_parameters()
	if !state_machine.parent_node.hitbox_component.is_staggered:
		state_machine.parent_node.velocity.x = idle_movement_speed * state_machine.parent_node.direction
	wander_time.start()

# Stop the enemy from moving
func _on_wander_time_timeout():
	if !state_machine.parent_node.hitbox_component.is_staggered:
		state_machine.parent_node.velocity.x = 0
	idle_time.start()

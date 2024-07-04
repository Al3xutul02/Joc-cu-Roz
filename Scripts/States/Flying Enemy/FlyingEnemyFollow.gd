extends State

# Exported variables
@export var follow_movement_speed: float = 200.0
@export var attack_distance: float = 400.0
@export var attack_close_distance: float = 200.0
@export var distance_from_player: float = 800.0
@export var aggro_time_duration: float = 1.0

# Imported variables
@onready var aggro_time = $AggroTime

# Nodes needed to interact with
var player: Player
var state_machine: StateMachine

func Enter():
	# Fetch needed nodes
	player = get_tree().get_first_node_in_group("Player")
	state_machine = get_parent()
	aggro_time.wait_time = aggro_time_duration

func Physics_Update(delta: float):
	# Calculate distance and direction
	var distance_vector: Vector2 = player.position - state_machine.parent_node.position
	var distance: float = distance_vector.length()
	state_machine.parent_node.direction = distance_vector.sign().x
	
	# Find out behaviour depending on distance
	if !state_machine.parent_node.hitbox_component.is_staggered:
		if abs(distance) > attack_distance:
			state_machine.parent_node.velocity = follow_movement_speed * distance_vector.normalized()
		elif abs(distance) < attack_close_distance:
			state_machine.parent_node.velocity = -follow_movement_speed * distance_vector.normalized()
		else:
			state_machine.parent_node.velocity = Vector2.ZERO
			Transitioned.emit(self, "EnemyAttack")
	
	# If distance is too big, then stop chasing
	if abs(distance) > distance_from_player:
		if aggro_time.is_stopped():
			aggro_time.start()
	else:
		aggro_time.stop()


func _on_aggro_time_timeout():
	Transitioned.emit(self, "EnemyIdle")

extends Node
class_name StateMachine

# Current state and dictionary for all states
var current_state: State
var states: Dictionary = {}

# Initial state at the beginning
@export var initial_state: State

# Nodes needed to interact with
var parent_node: Enemy

func _ready():
	# Get all children/possible states
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
	
	# Set the initial state
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
	# Get the parent node of the state machine
	parent_node = get_parent()

# Update the current state every frame
func _process(delta):
	if current_state:
		current_state.Update(delta)

# Update the current state every physics frame
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

# Transition state
func on_child_transition(state: State, new_state_name: String):
	# Check if state corresponds to the current state
	if state != current_state:
		return
	
	# Get the new state and check if it exists
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	# Exit function for the current state
	if current_state:
		current_state.Exit()
	
	# Enter function for the new state
	new_state.Enter()
	
	# New state is now the current state
	current_state = new_state

func _on_enemy_idle_transitioned(state: State, new_state_name: String):
	on_child_transition(state, new_state_name)


func _on_enemy_follow_transitioned(state: State, new_state_name: String):
	on_child_transition(state, new_state_name)

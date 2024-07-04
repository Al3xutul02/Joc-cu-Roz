extends State

# Exported variables
@export var distance_from_player: float = 100.0

# Nodes needed to interact with
var player: Player
var state_machine: StateMachine
var attack_component: AttackComponent

func Enter():
	# Get state macine parent, player and attack component of the state machine parent
	player = get_tree().get_first_node_in_group("Player")
	state_machine = get_parent()
	attack_component = state_machine.parent_node.attack_component

func Physics_Update(_delta: float):
	# Calculate distance and direction
	var distance: float = player.position.x - state_machine.parent_node.position.x
	state_machine.parent_node.direction = distance / abs(distance)
	
	# If player is close, attack
	if !state_machine.parent_node.hitbox_component.is_staggered:
		if abs(distance) < distance_from_player:
			if attack_component.can_attack:
				attack_component.attack_duration.start()
				attack_component.attack_cooldown.start()
				attack_component.enabled = true
				attack_component.visible = true
				attack_component.can_attack = false
		# Else, start following
		else:
			Transitioned.emit(self, "EnemyFollow")

extends State

# Exported variables
@export var distance_from_player: float = 200.0
@export var attack_time_duration: float = 0.7
@export var attack_movement_speed: float = 800.0

# Imported variables
@onready var attack_time = $AttackTime

# Nodes needed to interact with
var player: Player
var state_machine: StateMachine
var attack_component: AttackComponent

func Enter():
	# Get state macine parent, player and attack component of the state machine parent
	player = get_tree().get_first_node_in_group("Player")
	state_machine = get_parent()
	attack_component = state_machine.parent_node.attack_component
	attack_time.wait_time = attack_time_duration

func Physics_Update(_delta: float):
	# Calculate distance and direction
	var distance: float = player.position.x - state_machine.parent_node.position.x
	state_machine.parent_node.direction = distance / abs(distance)
	
	# If player is close, attack
	if !state_machine.parent_node.hitbox_component.is_staggered:
		if abs(distance) < distance_from_player:
			if attack_component.can_attack:
				attack_component.is_attacking = true
				attack_component.enabled = true
				attack_component.visible = true
				attack_component.can_attack = false
				state_machine.parent_node.velocity.x = attack_movement_speed * state_machine.parent_node.direction
				attack_time.start()
				attack_component.attack_cooldown.start()
		# Else, start following
		else:
			Transitioned.emit(self, "EnemyFollow")


func _on_attack_time_timeout():
	attack_component.is_attacking = false
	attack_component.enabled = false
	attack_component.visible = false
	Transitioned.emit(self, "EnemyFollow")

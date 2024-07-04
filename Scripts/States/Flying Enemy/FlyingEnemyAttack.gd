extends State

# Exported variables
@export var distance_from_player: float = 400.0
@export var attack_close_distance: float = 200.0
@export var projectile_speed: float = 200.0
@export var projectile_offset: Vector2 = Vector2(0, 50)
@export var attack_cooldown_duration: float = 2.0
@export var initial_cooldown_duration: float = 0.5

# Imported variables
@onready var attack_cooldown = $AttackCooldown
@onready var initial_cooldown = $InitialCooldown
@onready var projectile = load("res://Scenes/Projectiles/flying_enemy_projectile.tscn")

# Nodes needed to interact with
var player: Player
var state_machine: StateMachine
var level: Node2D

var can_attack: bool

func Enter():
	# Get state macine parent, player and attack component of the state machine parent
	player = get_tree().get_first_node_in_group("Player")
	state_machine = get_parent()
	level = player.get_parent()
	can_attack = false
	attack_cooldown.wait_time = attack_cooldown_duration
	initial_cooldown.wait_time = initial_cooldown_duration
	initial_cooldown.start()

func Physics_Update(_delta: float):
	# Calculate distance and direction
	var distance_vector: Vector2 = player.position - state_machine.parent_node.position - projectile_offset
	var distance: float = distance_vector.length()
	state_machine.parent_node.direction = distance_vector.x / abs(distance_vector.x)
	
	# If player is close, attack
	if !state_machine.parent_node.hitbox_component.is_staggered:
		if abs(distance) < distance_from_player and abs(distance) > attack_close_distance:
			if can_attack:
				var new_projectile = projectile.instantiate()
				new_projectile.position = state_machine.parent_node.position + projectile_offset
				new_projectile.velocity = distance_vector.normalized() * projectile_speed
				level.add_child.call_deferred(new_projectile)
				can_attack = false
				attack_cooldown.start()
				initial_cooldown.stop()
		# Else, start following
		else:
			Transitioned.emit(self, "EnemyFollow")


func _on_attack_cooldown_timeout():
	can_attack = true


func _on_initial_cooldown_timeout():
	can_attack = true

extends CharacterBody2D
class_name Player

# Exported variables
@export_group("Movement Parameters")
@export var speed: float = 400.0
@export var jump_velocity: float = -650.0
@export_group("Dash Parameters")
@export var dash_cooldown_time: float = 0.75
@export var dash_duration_time: float = 0.25

# Imported variables
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var dash_bar: ProgressBar = $DashBar
@onready var current_weapon = $Sword
@onready var ground_detector = $GroundDetector

# Timers
@onready var dash_cooldown: Timer = $timers/DashCooldown
@onready var dash_duration: Timer = $timers/DashDuration

var level_node: Node2D
var user_interface: UserInterface

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dash_speed: float = speed * 5
var direction: float = 1 

# Boolean variables
var can_dash: bool
var is_dashing: bool

# Initial state
func _ready():
	can_dash = true
	is_dashing = false
	dash_cooldown.wait_time = dash_cooldown_time
	dash_duration.wait_time = dash_duration_time
	dash_bar.max_value = dash_cooldown_time
	dash_bar.visible = false
	
	## Get the user interface for communicating
	# Get the parent
	level_node = get_parent()
	# Search for components in parent node
	var children_array: Array[Node] = level_node.get_children()
	for child_index in level_node.get_child_count():
		if children_array[child_index] is UserInterface:
			user_interface = children_array[child_index]

# Gets called on every frame
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	if is_dashing:
		velocity.x = velocity.sign().x * dash_speed
		velocity.y = 0
	else:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
	# Handle dashing
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_cooldown.start()
		dash_duration.start()
		can_dash = false
		is_dashing = true
		dash_bar.visible = true
		health_component.can_be_damaged = false
	
	# Handle basic attack
	if Input.is_action_just_pressed("attack") and attack_component.can_attack:
		attack_component.attack_duration.start()
		attack_component.attack_cooldown.start()
		attack_component.enabled = true
		attack_component.visible = true
		attack_component.can_attack = false

	## Handle weapons
	# Handle sword
	if Input.is_action_just_pressed("Weapon1") and current_weapon != Sword:
		current_weapon.queue_free()
		current_weapon = Sword.new()
		add_child(current_weapon)
	
	# Handle dagger
	if Input.is_action_just_pressed("Weapon2") and current_weapon != Dagger:
		current_weapon.queue_free()
		current_weapon = Dagger.new()
		add_child(current_weapon)
	
	# Handle scyche
	if Input.is_action_just_pressed("Weapon3") and current_weapon != Scythe:
		current_weapon.queue_free()
		current_weapon = Scythe.new()
		add_child(current_weapon)
	
	# Handle moving down a platform
	if Input.is_action_just_pressed("move_down") and ground_detector.is_colliding():
		var object = ground_detector.get_collider()
		if object is Platform:
			position.y += 1
	
	# Update attack hitbox according to direction
	if direction != 0:
		attack_component.position.x = direction * abs(attack_component.position.x)
	
	# Update the dash bar every frame if it is visible
	if dash_bar.visible:
		dash_bar.set_value_no_signal(dash_cooldown.time_left)
	
	move_and_slide()

# Called when the dash cooldown reaches 0
func _on_dash_cooldown_timeout():
	can_dash = true
	dash_bar.visible = false

# Called when the dash is finished
func _on_dash_duration_timeout():
	is_dashing = false
	health_component.can_be_damaged = true


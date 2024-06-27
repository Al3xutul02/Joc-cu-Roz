extends CharacterBody2D

# Exported variables
@export var speed: float = 300.0
@export var jump_velocity: float = -600.0
@export var dash_cooldown_time: float = 0.5
@export var dash_duration_time: float = 0.15

# Imported variables
@onready var health_component = $HealthComponent
@onready var attack_component = $AttackComponent
@onready var hitbox_component = $HitboxComponent

# Timers
@onready var dash_cooldown: Timer = $timers/DashCooldown
@onready var dash_duration: Timer = $timers/DashDuration

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dash_speed: float = speed * 5
var direction: int = 1

# Boolean variables
var can_dash: bool
var is_dashing: bool

# Initial state
func _ready():
	can_dash = true
	is_dashing = false
	dash_cooldown.wait_time = dash_cooldown_time
	dash_duration.wait_time = dash_duration_time

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
	
	# Handle basic attack
	if Input.is_action_just_pressed("attack") and attack_component.can_attack:
		attack_component.attack_duration.start()
		attack_component.attack_cooldown.start()
		attack_component.enabled = true
		attack_component.visible = true
		attack_component.can_attack = false
	
	# Update attack hitbox according to direction
	if direction != 0:
		attack_component.position.x = direction * abs(attack_component.position.x)
	
	move_and_slide()


func _on_dash_cooldown_timeout():
	can_dash = true


func _on_dash_duration_timeout():
	is_dashing = false


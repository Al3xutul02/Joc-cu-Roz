extends CharacterBody2D

# Exported variables
@export var speed: float = 300.0
@export var jump_velocity: float = -600.0
@export var dashCooldown: float = 0.5
@export var dashDuration: float = 0.15
@export var max_health: int = 100

# Imported variables
@onready var dash_cooldown: Timer = $timers/DashCooldown
@onready var dash_duration: Timer = $timers/DashDuration
@onready var attack_ray: ShapeCast2D = $AttackRay


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dash_speed: float = speed * 5
var health: int:
	set(value):
		health = clamp(value, 0, max_health)

# Boolean variables
var canDash: bool
var isDashing: bool

# Initial state
func _ready():
	canDash = true
	isDashing = false
	dash_cooldown.wait_time = dashCooldown
	dash_duration.wait_time = dashDuration
	health = max_health

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
	var direction = Input.get_axis("move_left", "move_right")
	if isDashing:
		velocity.x = velocity.sign().x * dash_speed
	else:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
	# Handle dashing
	if Input.is_action_just_pressed("dash") and canDash:
		dash_cooldown.start()
		dash_duration.start()
		canDash = false
		isDashing = true
	
	# Handle basic attack
	if Input.is_action_just_pressed("attack"):
		if attack_ray.is_colliding():
			# Check for every collision
			for iterator in attack_ray.get_collision_count():
				var enemy = attack_ray.get_collider(iterator)
				# Verify if it's an enemy
				if enemy is Enemy:
					enemy.health_component.set_damage_taken(30)
	
	move_and_slide()


func _on_dash_cooldown_timeout():
	canDash = true


func _on_dash_duration_timeout():
	isDashing = false

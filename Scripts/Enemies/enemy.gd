extends CharacterBody2D
class_name Enemy

# Get components
@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var hitbox_component: HitboxComponent
@export var health_bar: ProgressBar

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.value = health_component.health_pct
	health_bar.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Update attack hitbox according to direction
	if direction != 0:
		attack_component.position.x = direction * abs(attack_component.position.x)
	
	move_and_slide()

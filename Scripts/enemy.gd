extends CharacterBody2D
class_name Enemy

# Get components
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_bar: ProgressBar = $HealthBar

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.value = health_component.health_pct
	health_bar.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attack_component.can_attack:
		attack_component.attack_duration.start()
		attack_component.attack_cooldown.start()
		attack_component.enabled = true
		attack_component.visible = true
		attack_component.can_attack = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

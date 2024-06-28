extends RigidBody2D
class_name Enemy

# Get components
@onready var health_component = $HealthComponent
@onready var attack_component = $AttackComponent
@onready var hitbox_component = $HitboxComponent
@onready var health_bar = $HealthBar

var direction = -1

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

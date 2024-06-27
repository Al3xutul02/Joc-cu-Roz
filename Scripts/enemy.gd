extends RigidBody2D
class_name Enemy

# Get components
@onready var health_component = $HealthComponent
@onready var attack_component = $AttackComponent
@onready var hitbox_component = $HitboxComponent

var direction = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attack_component.can_attack:
		attack_component.attack_duration.start()
		attack_component.attack_cooldown.start()
		attack_component.enabled = true
		attack_component.visible = true
		attack_component.can_attack = false

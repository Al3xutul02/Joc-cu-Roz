extends Enemy
class_name FastEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.value = health_component.health_pct
	health_bar.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	# Update attack hitbox according to direction
	if direction != 0:
		attack_component.position.x = direction * abs(attack_component.position.x)
	
	move_and_slide()

extends Enemy
class_name FlyingEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.value = health_component.health_pct
	health_bar.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide()

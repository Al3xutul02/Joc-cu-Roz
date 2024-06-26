extends Node

class_name Enemy

@onready var health_component = $HealthComponent


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health_component.health == 0:
		self.free()

extends StaticBody2D

# Exported variables
@export var lever: Lever
@export var open_time_duration: float = 1.0
@export var open_speed: float = 250.0

# Imported variables
@onready var open_time = $OpenTime

var is_moving: bool
var is_opened: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	open_time.wait_time = open_time_duration
	is_moving = false
	is_opened = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# Check if the lever was modified and the door isn't moving
	if lever.is_opened != is_opened and !is_moving:
		is_moving = true
		is_opened = lever.is_opened
		open_time.start()
	
	# If if the door is moving, update position according to opened state
	if is_moving:
		if is_opened:
			position.y += open_speed * _delta
		else:
			position.y -= open_speed * _delta

func _on_open_time_timeout():
	is_moving = false

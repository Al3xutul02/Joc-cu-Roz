extends Node
class_name State

# Signal for transitioning between states
signal Transitioned

# Executes when first entering the State
func Enter():
	pass

# Executes when exiting the State
func Exit():
	pass

# Updates every frame
func Update(_delta: float):
	pass

# Updates according to the physics engine
func Physics_Update(_delta: float):
	pass

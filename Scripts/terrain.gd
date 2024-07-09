extends Node

func _ready():
	for child in get_children():
		if child is StaticBody2D:
			child.set_collision_layer_value(1, 1)
			child.set_collision_layer_value(2, 1)
			child.set_collision_layer_value(3, 1)
			child.set_collision_mask_value(1, 1)
			child.set_collision_mask_value(2, 1)
			child.set_collision_mask_value(3, 1)

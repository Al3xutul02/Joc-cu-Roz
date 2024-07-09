extends Node
class_name GameManager

# Nodes to interact with
var level: Node2D
var player: Player

enum Key_Color {
	Blue,
	Red
}

# Variables
var coins_gathered: int
var enemies_defeated: Dictionary = {}
var keys_collected: Array[Key_Color]

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent()
	player = get_tree().get_first_node_in_group("Player")
	coins_gathered = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_coin():
	coins_gathered += 1
	print(coins_gathered)
	for enemy in enemies_defeated:
		print(enemy)

func add_enemy(enemy: Enemy):
	enemies_defeated[enemy.name.to_lower()] = enemy

func add_key(key: Key_Color):
	keys_collected.append(key)

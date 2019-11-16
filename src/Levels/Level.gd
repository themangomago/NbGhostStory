extends Node

class_name Level

onready var playerScene = preload("res://src/Player/Player.tscn")
var player = null

func _ready():
	print("level ready")
	var gm = Global.getGameManager()
	gm.setWorlds($WorldDigable, $WorldNormal)
	
	spawnPlayer()

func spawnPlayer(at = "START"):
	print("spawn player")
	for spawn in get_tree().get_nodes_in_group("spawn"):
		if spawn.spawnName == at:
			player = playerScene.instance()
			player.position = spawn.position
			$Objects.add_child(player)
			break
	assert(player != null)


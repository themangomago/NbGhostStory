extends Node2D

class_name Level

onready var playerScene = preload("res://src/Player/Player.tscn")
var player = null

var debugCat

func _ready():
	print("Level: " + str(name))
	var gm = Global.getGameManager()
	gm.setWorlds($WorldDigable, $WorldNormal)
	
	spawnPlayer()
	DebugSetup()
	

func DebugSetup():
	if Global.debug:
		debugCat = Debug.addCategory("SpawnAt")
		print("cat: " + str(debugCat))
		Debug.clearOptions(debugCat)
		for spawn in get_tree().get_nodes_in_group("spawn"):
			#addOption(category, optionName, callback, parameter):
			Debug.addOption(debugCat, str(spawn.name + " (" + spawn.spawnName  + ")" ), funcref(self, "DebugPortPlayer"), str(spawn.name))

func DebugPortPlayer(to):
	assert(player != null)
	for spawn in get_tree().get_nodes_in_group("spawn"):
		if spawn.name == to:
			print(spawn.get_global_position())
			player.position = spawn.get_global_position()
			player.restartPoint = spawn.get_global_position()
			# var pos = (player.position / Vector2(480, 272))
			# if pos.y < 0: pos.y -= 1
			# if pos.x < 0: pos.x -= 1
			# pos = Vector2(int(pos.x), int(pos.y))
			Global.getCam().transitionToScreen(player.position)
			break
			

func spawnPlayer(at = "START"):
	for spawn in get_tree().get_nodes_in_group("spawn"):
		if spawn.spawnName == at: #TODO: maybe rely on real spawn name or make a tick for start node
			player = playerScene.instance()
			player.position = spawn.position
			$Objects.add_child(player)
			break
	assert(player != null)


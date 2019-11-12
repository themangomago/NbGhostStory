extends Control

#TODO:
# - Lava
# - Light deactive/shadow deactive for enemy in get_tree().get_nodes_in_group("light)
# - Level Transition
# - Stage Transition and restart (kill)

# - UI (Deadcount, Time, Apples)
# - Menu
# - Savegame

# - Levels

enum GameStates {Menu, Game} 

var state = GameStates.Menu

var worldDigable = null
var worldNormal = null

onready var col = $col
onready var end = $end

onready var level0 = preload("res://src/Levels/Level0.tscn")

func _ready():
	print("gm")
	Global.setGameManager(self)
	Global.debugLabel = $gameViewport/Viewport/Debug
	
	loadLevel()

func loadLevel():
	var level = level0.instance()
	$gameViewport.get_node("Viewport/LevelHolder").add_child(level)

func reset():
	for node in get_tree().get_nodes_in_group("resetState"):
		node.reset()

func getTilePosition(pos):
	var coords = worldDigable.world_to_map(pos)
	#print(coords)
	return coords

func getTileValidity(coords):
	var validity = false
	var tileId = worldDigable.get_cellv(coords)
	if tileId != -1:
		if worldNormal.get_cellv(coords) == -1:
			validity = true
	#print(tileId)
	return validity

func setWorlds(digable, normal):
	worldDigable = digable
	worldNormal = normal

func stateTransition(to):
	if to == GameStates.Menu:
		$gameViewport.hide()
		$menuViewport.show()
	elif to == GameStates.Game:
		$gameViewport.show()
		$menuViewport.hide()


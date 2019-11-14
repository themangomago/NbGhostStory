extends Control

#TODO:
# - Light deactive/shadow deactive for enemy in get_tree().get_nodes_in_group("light)
# - UI (Deadcount, Time, Apples)
# - Menu
# - Savegame

# - Levels

# Justify https://godotengine.org/qa/39374/godot-xyz-declared-but-never-used-the-script-how-store-vars-now



var state = Types.GameStates.Menu

var worldDigable = null
var worldNormal = null
var level = null

var deadCount = 0
var time = 0

var indicator = Types.IndicatorLevel.Lite
var lights = true

onready var level0 = preload("res://src/Levels/Level0.tscn")

func _ready():
	print("gm")
	Global.setGameManager(self)
	Global.debugLabel = $gameViewport/Viewport/Camera/Debug
	
	# Init HUD
	Global.getHUD().init()
	
	stateTransition(Types.GameStates.Menu)
	loadLevel()

func _physics_process(delta):
	if state == Types.GameStates.Game:
		time += delta

func setLevel(node):
	level = node

func getLevel():
	return level

func loadLevel():
	var levelInstance = level0.instance()
	$gameViewport.get_node("Viewport/LevelHolder").add_child(levelInstance)

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
	if to == Types.GameStates.Menu:
		$gameViewport.hide()
		$menuViewport.show()
		Global.getHUD().hide()
	elif to == Types.GameStates.Game:
		$gameViewport.show()
		$menuViewport.hide()
		Global.getHUD().show()
	state = to

func continueGame():
	stateTransition(Types.GameStates.Game)
	
func newGame():
	stateTransition(Types.GameStates.Game)

func setLights(state):
	lights = state

func setIndicator(to):
	indicator = to

func getLights():
	return lights

func getIndicator():
	return indicator

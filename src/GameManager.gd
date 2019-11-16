extends Control

#TODO:
# - Levels

# Justify https://godotengine.org/qa/39374/godot-xyz-declared-but-never-used-the-script-how-store-vars-now

var state = Types.GameStates.Menu

var worldDigable = null
var worldNormal = null
var levelNode = null
var levelId = 0
var completed = false

var deadCount = 0
var time = 0

var indicator = Types.IndicatorLevel.Lite
var lights = true

var nextLevelFlag = false

# Game Active
var active = false
var saveAvailable = false

const levels = [
	"res://src/Levels/Tut1.tscn",
	"res://src/Levels/Level0.tscn",
	"res://src/Levels/Level1.tscn",
	"res://src/Levels/LevelEnd.tscn",
]


func _ready():
	print("gm")
	Global.setGameManager(self)
	Global.debugLabel = $Debug
	
	# Load saved state
	loadGame()

	# Init HUD
	Global.getHUD().init()
	
	stateTransition(Types.GameStates.Menu)

func _physics_process(delta):
	Global.debugLabel.set_text(str(state))
	if state == Types.GameStates.Game and not completed:
		time += delta
		
		if nextLevelFlag:
			nextLevelFlag = false
			nextLevel()


# Save Game
func saveGame():
	var save = {
		"level": levelId,
		"dead": deadCount,
		"time": time
	}
	var cfgFile = File.new()
	cfgFile.open("user://save.cfg", File.WRITE)
	cfgFile.store_line(to_json(save))
	cfgFile.close()

# Load Game
func loadGame():
	var cfgFile = File.new()
	if  cfgFile.file_exists("user://save.cfg"):
		cfgFile.open("user://config.cfg", File.READ)
		var data = parse_json(cfgFile.get_line())
		levelId = data.level
		deadCount = data.dead
		time = data.time
		saveAvailable = true


func updateLights():
	for light in get_tree().get_nodes_in_group("light"):
		light.enabled = lights

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
		if levelNode or saveAvailable:
			Global.menu.updateMenu(true)
		else:
			Global.menu.updateMenu(false)
		Global.getHUD().hide()
	elif to == Types.GameStates.Game:
		$gameViewport.show()
		$menuViewport.hide()
		Global.getHUD().show()
		updateLights()
	state = to

func loadLevel(number = 0):
	levelNode = load(levels[number]).instance()
	$gameViewport.get_node("Viewport/LevelHolder").add_child(levelNode)
	updateLights()
	$gameViewport/Viewport/AnimationLevelFade.play("levelFade")

func unloadLevel():
	$gameViewport.get_node("Viewport/LevelHolder").remove_child(levelNode)
	levelNode.queue_free()
	levelNode = null

func nextLevel():
	levelId += 1
	unloadLevel()
	loadLevel(levelId)
	
	if levelId < levels.size() - 1:
		Global.hud.save()
	else:
		completed = true

func continueGame():
	if not levelNode:
		print("load level from save")
	stateTransition(Types.GameStates.Game)
	active = true
	
func newGame():
	if levelNode:
		unloadLevel()
		deadCount = 0
		time = 0
	loadLevel(0)
	stateTransition(Types.GameStates.Game)
	active = true

func setLights(state):
	lights = state

func setIndicator(to):
	indicator = to

func getLights():
	return lights

func getIndicator():
	return indicator

func save():
	Global.hud.save()

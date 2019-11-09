extends Node2D

#TODO:
# - Lava
# - Light deactive/shadow deactive for enemy in get_tree().get_nodes_in_group("light)
# - Level Transition
# - Stage Transition and restart (kill)

# - UI (Deadcount, Time, Apples)
# - Menu
# - Savegame

# - Levels



onready var col = $col
onready var end = $end
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setGameManager(self)
	Global.debugLabel = $Debug

func reset():
	for node in get_tree().get_nodes_in_group("resetState"):
		node.reset()

func getTilePosition(pos):
	var coords = $WorldDigable.world_to_map(pos)
	#print(coords)
	return coords

func getTileValidity(coords):
	var validity = false
	var tileId = $WorldDigable.get_cellv(coords)
	if tileId != -1:
		if $WorldNormal.get_cellv(coords) == -1:
			validity = true
	#print(tileId)
	return validity

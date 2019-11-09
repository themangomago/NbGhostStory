extends Node2D

#TODO:
# - Jumppad
# - Bubble Reset jump/dash

# - Light deactive/shadow deactive for enemy in get_tree().get_nodes_in_group("light)

onready var col = $col
onready var end = $end
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setGameManager(self)
	Global.debugLabel = $Debug

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

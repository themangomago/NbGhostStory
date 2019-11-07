extends Node2D

onready var col = $col
onready var end = $end
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setGameManager(self)
	Global.debugLabel = $Debug


extends Node2D

func _ready():
	if Global.gm:
		Global.gm.setWorlds($WorldDigable, $WorldNormal)

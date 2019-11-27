extends Position2D

export(String) var spawnName = "START"

const HIDE = true

func _ready():
	if not Global.debug or HIDE:
		$Sprite.hide()

func getPoint():
	print(spawnName)

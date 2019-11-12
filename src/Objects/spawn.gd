extends Position2D

export(String) var spawnName = "START"

func _ready():
	if not Global.debug:
		$Sprite.hide()

func getPoint():
	print(spawnName)

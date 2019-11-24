extends Node2D

export(bool) var requireKey = false

func _ready():
	if requireKey:
		$Bars.show()
	else:
		$Bars.hide()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if not requireKey:
			Global.getGameManager().nextLevelFlag = true
			return

		if Global.getGameManager().hasKey or body.hasKeyNotSave:
			Global.getGameManager().nextLevelFlag = true
		else:
			$AudioStreamPlayer2D.play()
			



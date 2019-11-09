extends Node2D

export(Types.Direction) var direction = Types.Direction.Right

func _ready():
	$Rotator/Spike.show()
	$Editor.hide()

	match direction:
		Types.Direction.Left:
			$Rotator.rotate(-PI)
		Types.Direction.Top:
			$Rotator.rotate(deg2rad(-90))
		Types.Direction.Down:
			$Rotator.rotate(deg2rad(90))

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		print("ouch")

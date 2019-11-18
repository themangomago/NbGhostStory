extends Node2D

export(Types.Direction) var direction = Types.Direction.Top
export(int) var tiles = 3

const SPEED_PER_TILE = 0.5

var tweenValues = [Vector2(), Vector2()] 

func _ready():
	tweenValues[0] = position
	match direction:
		Types.Direction.Top:
			tweenValues[1] = Vector2(position.x, position.y - tiles * 16)
		Types.Direction.Down:
			tweenValues[1] = Vector2(position.x, position.y + tiles * 16)
		Types.Direction.Left:
			tweenValues[1] = Vector2(position.x - tiles * 16, position.y)
		_:
			tweenValues[1] = Vector2(position.x + tiles * 16, position.y)
	tweenStart()


func tweenStart():
	$Tween.interpolate_property(self, "position", position, tweenValues[1], SPEED_PER_TILE * tiles, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

#warning-ignore:unused_argument
#warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	tweenValues.invert()
	tweenStart()


func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		body.onPlatform = true


func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		body.onPlatform = false

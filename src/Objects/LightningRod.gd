extends Node2D

const SPEED_PER_TILE = 0.5

export(int) var heigth = 4 #y
export(int) var tiles = 5 #x
export(Types.Direction) var direction = Types.Direction.Left


onready var sprite1 = preload("res://assets/art/objects/lightning1.png")
onready var sprite2 = preload("res://assets/art/objects/lightning2.png")

var tweenValues = [Vector2(), Vector2()] 

func _ready():
	tweenValues[0] = position
	match direction:
		Types.Direction.Left:
			tweenValues[1] = Vector2(position.x - tiles * 16, position.y)
		_:
			tweenValues[1] = Vector2(position.x + tiles * 16, position.y)
		
	#Bottom
	$Bottom.position = Vector2(0, 16) * (heigth - 1)

	var shape = RectangleShape2D.new()
	shape.extents = Vector2(0 , 8) * (heigth) + Vector2(4, 0)
	$Area2D/CollisionShape2D.set_shape(shape)
	$Area2D/CollisionShape2D.position = Vector2(0,16) * (float(heigth)/2) + Vector2(8, 0)

	#Setup Animation
	for i in range(heigth):
		var sprite = AnimatedSprite.new()
		sprite.set_sprite_frames($Reference.get_sprite_frames())
		sprite.set_animation("default")
		sprite.play("default")
		sprite.position = Vector2(0, 16) * (i) + Vector2(8,8)
		sprite.z_index = 4
		self.add_child(sprite)
		
	runTween()


func runTween():
	$Tween.interpolate_property(self, "position", position, tweenValues[1], SPEED_PER_TILE * tiles, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	tweenValues.invert()
	runTween()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if Global.getGameManager().active:
			if not body.getDig():
				body.kill()

extends Node2D

export(int) var length = 5
export(int) var angle = 0
export(int) var time = 3

onready var chainImage = preload("res://assets/art/objects/spikechain.png")


func _ready():
	$rotator/Ball.position = Vector2(16, 0) * (length - 1)
	$rotator/Area2D/CollisionShape2D.position = Vector2(16,0) * (float(length)/2)
	#var shape = $rotator/KinematicBody2D/CollisionShape2D.get_shape()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(8 , 0) * (length - 1) + Vector2(0, 4)
	$rotator/Area2D/CollisionShape2D.set_shape(shape)
	
	
	for i in range(length - 2):
		var sprite = Sprite.new()
		sprite.set_texture(chainImage)
		sprite.position = Vector2(16, 0) * (i + 1)
		$rotator.add_child(sprite)
	
	$rotator.rotation_degrees = angle
	runTween()


func runTween():
	var timeUp:float = 1.0
	if angle != 0:
		timeUp = 1 - float(angle)/360
	
	$Tween.interpolate_property($rotator, "rotation_degrees", angle, 360, time * timeUp, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	angle = 0


func _on_Tween_tween_completed(object, key):
	runTween()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if Global.getGameManager().active:
			if not body.getDig():
				body.kill()

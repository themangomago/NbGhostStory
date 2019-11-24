extends Node2D

onready var pickupNode = preload("res://src/Objects/Pickup.tscn")

var alive = true

func reset():
	self.show()
	$Area/CollisionShape2D.disabled = false
	alive = true

func remove():
	self.hide()
	$Area/CollisionShape2D.disabled = true
	alive = false

func _on_Area_body_entered(body):
	if body.is_in_group("player") and alive:
		var new = pickupNode.instance()
		new.position = position
		get_parent().add_child(new)
		var apples = Global.getGameManager().applesUnsave 
		Global.getGameManager().applesUnsave = apples + 1
		remove()
		$AudioStreamPlayer2D.play()
		

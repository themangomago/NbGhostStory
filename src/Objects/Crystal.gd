extends Node2D

onready var pickupNode = preload("res://src/Objects/Pickup.tscn")

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		$Sprite.hide()
		var new = pickupNode.instance()
		new.position = position
		get_parent().add_child(new)
		
		get_parent().remove_child(self)
		queue_free()

extends Node2D

onready var pickupNode = preload("res://src/Objects/Pickup.tscn")

var alive = true

func reset():
	$Area/CollisionShape2D.disabled = false
	alive = true
	$Empty.hide()
	$Body.show()
	$RespawnTimer.stop()

func remove():
	$Area/CollisionShape2D.disabled = true
	alive = false
	$Empty.show()
	$Body.hide()
	$RespawnTimer.start()

func _on_Area_body_entered(body):
	if body.is_in_group("player") and alive:
		
		body.dodgeAvailable = true
		
		var new = pickupNode.instance()
		new.position = position
		get_parent().add_child(new)
		remove()
		$AudioStreamPlayer2D.play()


func _on_RespawnTimer_timeout():
	reset()

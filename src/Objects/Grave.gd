extends Node2D


func _on_Timer_timeout():
	$Text.hide()





func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$Text.show()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		$Timer.start()

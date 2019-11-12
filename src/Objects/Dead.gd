extends Area2D

func _on_Transition_body_entered(body):
	if body.is_in_group("player"):
		body.kill()

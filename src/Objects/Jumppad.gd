extends Node2D

var triggerd = false

func _on_Area_body_entered(body):
	if body.is_in_group("player") and not triggerd:
		if body.isStateNormal():
			body.isOnJumpPad = true
			triggerd = true
			$AnimationPlayer.play("jump")
			


func _on_AnimationPlayer_animation_finished(anim_name):
	triggerd = false

extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().remove_child(self)
	queue_free()

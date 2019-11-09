extends Node2D

func init(direction, frame):
	$Sprite.flip_h = direction
	$Sprite.frame = frame
	

func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().remove_child(self)
	queue_free()

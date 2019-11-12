extends Node2D

func init(direction, frame):
	$Sprite.flip_h = direction
	$Sprite.frame = frame
	

func _on_AnimationPlayer_animation_finished(anim_name):
	assert(anim_name != null)
	get_parent().remove_child(self)
	queue_free()

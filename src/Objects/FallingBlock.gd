extends Node2D

var body = null
var doomed = false

func _ready():
	reset()

func fallDown():
	$AnimationPlayer.play("falldown")
	$StaticBody2D.hide()
	$Empty.show()
	$StaticBody2D/CollisionShape2D.disabled = true
	$Area/CollisionShape2D.disabled = true
	$RespawnTimer.start()


func reset():
	$Empty.hide()
	$Block.self_modulate = Color(1,1,1,1)
	$Block.position = Vector2(0,0)
	$StaticBody2D/CollisionShape2D.disabled = false
	$Area/CollisionShape2D.disabled = false
	$RespawnTimer.stop()
	body = null
	doomed = false
	$AnimationPlayer.stop()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shackleton":
		fallDown()

func _on_RespawnTimer_timeout():
	reset()

func _on_Area_body_entered(body):
	if body.is_in_group("player") and not doomed:
		if body.isStateNormal():
			self.body = body
			$CheckTimer.start()
			#TODO: might be a problem if the player dashes directly into the area

func _on_Area_body_exited(body):
	if body.is_in_group("player") and not doomed:
		body = null

func _on_CheckTimer_timeout():
	doomed = true
	$AnimationPlayer.play("shackleton")




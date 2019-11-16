extends Node2D

export(String) var text = ""

func _ready():
	$Text.bbcode_text = "[center]"+ str(text) + "[/center]"

func _on_Timer_timeout():
	$Text.hide()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$Text.show()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		$Timer.start()

extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func speak(line):
	match line:
		1:
			$Lj1/T1.start()
		2: 
			$Boss/T2.start()
		3: 
			$Lj2/T3.start()
		4:
			$Boss/T4.start()
		5:
			$Lj1/T5.start()
		6:
			$Lj2/T6.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().get_parent().anim()

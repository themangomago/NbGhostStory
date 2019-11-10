extends Camera2D

enum CamStates {Static, Transition}

var state = CamStates.Static

func _ready():
	Global.setCam(self)

func transition(direction):
	if state == CamStates.Static:
		print("cammera")


extends Camera2D

enum CamStates {Static, Transition}

var state = CamStates.Static

onready var tween = $Tween


func _ready():
	Global.setCam(self)
	DebugSetup()

func DebugSetup():
	if Global.debug:
		var debugCat = Debug.addCategory("CamInfo")
		Debug.addOption(debugCat, "Position" , funcref(self, "DebugGetPosition"), null)

func DebugGetPosition(to):
	print(position)

func switchToScreen(to):
	print("switchToScreen" + str(to) )
	var pos = (to / Vector2(480, 272))
	if pos.y < 0: pos.y -= 1
	if pos.x < 0: pos.x -= 1
	pos = Vector2(int(pos.x), int(pos.y))
	position = pos * Vector2(480, 272)

func transitionToScreen(to):
	print("transitionToScreen" + str(to) )
	var pos = (to / Vector2(480, 272))
	if pos.y < 0: pos.y -= 1
	if pos.x < 0: pos.x -= 1
	pos = Vector2(int(pos.x), int(pos.y))
	var end = pos * Vector2(480, 272)
	tween.interpolate_property(self, 'position', self.position, end, 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	state = CamStates.Transition

func reset():
	print("reset cam")
	tween.stop_all()
	position = Vector2(0, 0)
	state = CamStates.Static

#warning-ignore:unused_argument
#warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	state = CamStates.Static

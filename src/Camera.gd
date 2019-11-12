extends Camera2D

enum CamStates {Static, Transition}

var state = CamStates.Static

onready var levelHolder = get_parent().get_node("LevelHolder")
onready var tween = $Tween


func _physics_process(delta):
	get_node("Debug").set_text(str(position))

func _ready():
	Global.setCam(self)

func transitionToScreen(to):
	var end = to * Vector2(480, 272)
	tween.interpolate_property(self, 'position', self.position, end, 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	state = CamStates.Transition


#func transition(direction):
#	# # 480x270  | 12	
#	if state == CamStates.Static:
#		var end = position
#		match direction:
#			Types.Direction.Right:
#				end += Vector2(480, 0)
#			Types.Direction.Left:
#				end -= Vector2(480, 0)
#			Types.Direction.Top:
#				end -= Vector2(0, 272)
#			Types.Direction.Down:
#				end += Vector2(0, 272)
#
#		tween.interpolate_property(self, 'position', self.position, end, 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
#		tween.start()
#		state = CamStates.Transition
#		return true
#	return false


func _on_Tween_tween_completed(object, key):
	state = CamStates.Static

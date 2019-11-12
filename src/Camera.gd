extends Camera2D

enum CamStates {Static, Transition}

var state = CamStates.Static

onready var levelHolder = get_parent().get_node("LevelHolder")
onready var tween = levelHolder.get_node("Tween")

func _ready():
	Global.setCam(self)

func transition(direction):
	# # 480x270  | 12	
	if state == CamStates.Static:
		var end = levelHolder.position
		match direction:
			Types.Direction.Right:
				end -= Vector2(480, 0)
			Types.Direction.Left:
				end += Vector2(480, 0)
			Types.Direction.Top:
				end += Vector2(0, 272)
			Types.Direction.Down:
				end -= Vector2(0, 272)

		tween.interpolate_property(levelHolder, 'position', levelHolder.position, end, 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()
		state = CamStates.Transition


func _on_Tween_tween_completed(object, key):
	state = CamStates.Static

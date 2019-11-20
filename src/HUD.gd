extends CanvasLayer

var connected = false

func init():
	connected = true

func _ready():
	Global.setHUD(self)


func hide():
	$Time.hide()
	$Dead.hide()
	
func show():
	$Time.show()
	$Dead.show()

func save():
	$AnimationSave.play("save")

func _physics_process(delta):
	if connected:
		var gm = Global.getGameManager()
		var time = gm.time
		
		var timeString = Global.timeToString(time)
		
		$Time.set_text("¦ " +  timeString)
		
		$Dead.set_text("€ " + str(gm.deadCount))

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


func _physics_process(delta):
	if connected:
		var gm = Global.getGameManager()
		var time = gm.time
		
		var minutes = "%02d" % [time / 60]
		var seconds = "%02d" % [int(time) % 60]
		var ms = "%03d" % [int(time*1000) % 1000]
		
		$Time.set_text("¦ " +  minutes + ":" + seconds + ":"+ ms)
		
		$Dead.set_text("€ " + str(gm.deadCount))

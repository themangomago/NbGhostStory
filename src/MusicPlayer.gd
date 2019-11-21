extends AudioStreamPlayer



onready var musicTable = [
	#0 Main
	{"intro": preload("res://assets/music/0MainIntro.wav"), "loop": preload("res://assets/music/0MainLoop.wav")},
	#1
	{"intro": preload("res://assets/music/1Intro.wav"), "loop": preload("res://assets/music/1Loop.wav")},
	#2
	{"intro": preload("res://assets/music/2Intro.wav"), "loop": preload("res://assets/music/2Loop.wav")},
	#3
	{"intro": preload("res://assets/music/3Intro.wav"), "loop": preload("res://assets/music/3Loop.wav")},
	#4
	{"intro": preload("res://assets/music/4Intro.wav"), "loop": preload("res://assets/music/4Loop.wav")}
]

var stage = 0
var introFinished = false
var AudioStream

func _ready():
	DebugSetup()
	playMusic(0)

func DebugSetup():
	if Global.debug:
		var debugCat = Debug.addCategory("MusicPlayer")
		Debug.addOption(debugCat, "Play 0 " , funcref(self, "playMusic"), 0)
		Debug.addOption(debugCat, "Play 1 " , funcref(self, "playMusic"), 1)
		Debug.addOption(debugCat, "Play 2 " , funcref(self, "playMusic"), 2)
		Debug.addOption(debugCat, "Play 3 " , funcref(self, "playMusic"), 3)
		Debug.addOption(debugCat, "Play 4 " , funcref(self, "playMusic"), 4)

func playMusic(thisStage):
	stage = thisStage
	if self.is_playing():
		self.stop()
	
	introFinished = false
	self.set_stream(musicTable[stage].intro)
	self.play()

func _on_MusicPlayer_finished():
	if introFinished == false:
		introFinished = true
		self.set_stream(musicTable[stage].loop)

	self.play()


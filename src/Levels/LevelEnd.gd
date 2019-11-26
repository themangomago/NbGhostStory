extends Control

func _ready():
#	var deadCount = 0
#	var time = 0
#	var apples = 0
	Global.getHUD().hide()
	var apples = Global.getGameManager().apples
	var time = Global.getGameManager().time
	var deadCount = Global.getGameManager().deadCount
	$bg/Highscore.bbcode_text = "[center]Score\n¦ " + Global.timeToString(time) + "\n€ "+ str(deadCount) +"\nà "+ str(apples) +"[/center]"
	$bg.hide()
	$LevelEndScene.show()

	if time < Global.userConfig.highscore.time or Global.userConfig.highscore.time == 0:
		$bg/New.show()
		Global.userConfig.highscore.time = time
		Global.userConfig.highscore.apples = apples
		Global.userConfig.highscore.dead = deadCount
		Global.saveConfig()

func anim():
	$bg.show()
	$LevelEndScene.hide()

func _on_BtnBack_button_up():
	Global.getHUD().show()
	Global.getGameManager().stateTransition(Types.GameStates.Menu)
	$Click.play()
	

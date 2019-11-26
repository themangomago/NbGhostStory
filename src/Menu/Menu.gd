extends Control

enum MenuState {Main, Settings, Controls}

func _ready():
	Global.setMenu(self)
	$Version.bbcode_text = "[right]"+ Global.getVersionString() + "[/right]"

func updateMenu(continueAvailable):
	if continueAvailable:
		$Main/ButtonContinue.show()
	else:
		$Main/ButtonContinue.hide()
		
	if Global.userConfig.highscore.time > 0:
		updateHighscore()
		$Main/Highscore.show()
	else:
		$Main/Highscore.hide()

func updateHighscore():
	$Main/Highscore.bbcode_text = "Highscore\n¦ " + Global.timeToString(Global.userConfig.highscore.time) + "\n€ "+ str(Global.userConfig.highscore.dead) +"\nà "+ str(Global.userConfig.highscore.apples) +"\n"

func advertise():
	_on_ButtonBack_button_up()
	
	if $AdvertiseWindow.visible:
		$AdvertiseWindow.hide()
	else:
		$AdvertiseWindow.show()
	

func _on_ButtonContinue_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		Global.getGameManager().continueGame()
		$Click.play()

func _on_ButtonPlay_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		Global.getGameManager().newGame()
		$Click.play()

func _on_ButtonSettings_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		stateTransition(MenuState.Settings)
		$Click.play()

func _on_ButtonExit_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		$Click.play()
		print("Ok, Bye! Thanks for playing.")
		get_tree().quit()

func stateTransition(to):
	if to == MenuState.Main:
		$Settings.hide()
		$Main.show()
		$Controls.hide()
	elif to == MenuState.Settings:
		updateSettings()
		$Settings.show()
		$Controls.hide()
		$Main.hide()
	elif to == MenuState.Controls:
		$Settings.hide()
		$Main.hide()
		$Controls.show()

func updateSettings():
	var lights = Global.getGameManager().getLights()
	var indicator = Global.getGameManager().getIndicator()
	
	if lights:
		$Settings/ButtonLights/Text.bbcode_text = "[center]Light: On[/center]"
	else:
		$Settings/ButtonLights/Text.bbcode_text = "[center]Light: Off[/center]"

	if indicator == Types.IndicatorLevel.Off:
		$Settings/ButtonIndicator/Text.bbcode_text = "[center]Indicator: Off[/center]"
	elif indicator == Types.IndicatorLevel.Lite:
		$Settings/ButtonIndicator/Text.bbcode_text = "[center]Indicator: Lite[/center]"
	else:
		$Settings/ButtonIndicator/Text.bbcode_text = "[center]Indicator: Full[/center]"
	
	if Global.userConfig.fullscreen:
		$Settings/ButtonFullscreen/Text.bbcode_text = "[center]Fullscreen: On[/center]"
	else:
		$Settings/ButtonFullscreen/Text.bbcode_text = "[center]Fullscreen: Off[/center]"

func _on_ButtonBack_button_up():
	stateTransition(MenuState.Main)
	$Click.play()


func _on_ButtonLights_button_up():
	var lights = Global.getGameManager().getLights()
	Global.getGameManager().setLights(!lights)
	updateSettings()
	$Click.play()


func _on_ButtonIndicator_button_up():
	var indicator = Global.getGameManager().getIndicator()
	if indicator == Types.IndicatorLevel.Off:
		Global.getGameManager().setIndicator(Types.IndicatorLevel.Lite)
	elif indicator == Types.IndicatorLevel.Lite:
		Global.getGameManager().setIndicator(Types.IndicatorLevel.Full)
	else:
		Global.getGameManager().setIndicator(Types.IndicatorLevel.Off)
	updateSettings()
	$Click.play()


func _on_ButtonControls_button_up():
	stateTransition(MenuState.Controls)
	$Click.play()


func _on_ButtonFullscreen_button_up():
	Global.fullscreen()
	updateSettings()
	$Click.play()
	


func _on_ButtonItch_button_up():
	$Click.play()
	OS.shell_open("https://nimblebeasts.itch.io/")


func _on_ButtonTwitter_button_up():
	$Click.play()
	OS.shell_open("https://twitter.com/nimblebeasts")


func _on_ButtonNewsletter_button_up():
	$Click.play()
	OS.shell_open("https://nimblebeasts.co")


func _on_ButtonGameJolt_button_up():
	$Click.play()
	OS.shell_open("https://gamejolt.com/@NimbleBeasts")

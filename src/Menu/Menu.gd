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

func _on_ButtonContinue_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		Global.getGameManager().continueGame()

func _on_ButtonPlay_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		Global.getGameManager().newGame()

func _on_ButtonSettings_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
		stateTransition(MenuState.Settings)

func _on_ButtonExit_button_up():
	if Global.getGameManager().state == Types.GameStates.Menu:
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

func _on_ButtonBack_button_up():
	stateTransition(MenuState.Main)


func _on_ButtonLights_button_up():
	var lights = Global.getGameManager().getLights()
	Global.getGameManager().setLights(!lights)
	updateSettings()


func _on_ButtonIndicator_button_up():
	var indicator = Global.getGameManager().getIndicator()
	if indicator == Types.IndicatorLevel.Off:
		Global.getGameManager().setIndicator(Types.IndicatorLevel.Lite)
	elif indicator == Types.IndicatorLevel.Lite:
		Global.getGameManager().setIndicator(Types.IndicatorLevel.Full)
	else:
		Global.getGameManager().setIndicator(Types.IndicatorLevel.Off)
	updateSettings()


func _on_ButtonControls_button_up():
	stateTransition(MenuState.Controls)

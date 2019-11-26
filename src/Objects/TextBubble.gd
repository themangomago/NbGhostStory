extends Node2D

export(String) var text = ""
export(bool) var suprise = false

enum voice {normal, loud}

var lapsed = 0
var charNum = 0
var start = false
var firstStart = true

func _ready():
	$Text.bbcode_text = "[center]"+ str(text) + "[/center]"
	lapsed = 0
	$Text.set_visible_characters(0)
	$Text.hide()

func _on_Timer_timeout():
	$Text.hide()

func start():
	$Text.set_visible_characters(0)
	$Text.show()
	firstStart = true
	charNum = 0
	lapsed = 0
	start = true

func _physics_process(delta):
	if start:
		if suprise and firstStart:
			$SndHa.play()
			firstStart = false
		elif not $SndBlah.is_playing() and not $SndHa.is_playing():
			$SndBlah.play()

		lapsed = lapsed + delta
		charNum = $Text.set_visible_characters(lapsed / .03)
		
		if $Text.get_visible_characters() >= $Text.get_total_character_count():
			start = false
			$Timer.start()

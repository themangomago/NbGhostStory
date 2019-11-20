extends Node2D

export(String) var text = ""
export(bool) var suprise = false

var lapsed = 0
var charNum = 0
var start = false
var firstStart = true

func _ready():
	$Text.bbcode_text = "[center]"+ str(text) + "[/center]"
	lapsed = 0
	$Text.set_visible_characters(0)

func _on_Timer_timeout():
	$Text.hide()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$Text.set_visible_characters(0)
		$Text.show()
		firstStart = true
		charNum = 0
		lapsed = 0
		start = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		$Timer.start()
		$SndBlah.stop()
		$SndHa.stop()
		start = false
		print("stop")


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

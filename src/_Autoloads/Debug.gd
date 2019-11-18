extends Node

var menuOpen = false
var options = []

func _ready():
#	addOption("Variant 1", funcref(self, "test"), true)
#	addOption("Variant 2", funcref(self, "test"), 15)
#	addOption("Variant 3", funcref(self, "test"), "string")
	pass

func _input(event):
	if Global.debug:
		if event is InputEventKey and not event.is_echo():
			if event.pressed:
				#Close Debug Menu
				if menuOpen and event.scancode == KEY_ESCAPE:
					menuOpen = false
				#Open Debug Menu
				elif event.scancode == KEY_F4:
					_displayMenu()
					print(">")
					menuOpen = true
				elif menuOpen:
					_handleOptions(event.scancode)

func _displayMenu():
	print(" ")
	print("Menu============")
	for points in options:
		print(str(points.index) + "." + points.name)
	print("================")

func _handleOptions(code):
	if code >= KEY_0 and code <= KEY_9:
		var index = code - KEY_0
		for point in options:
			if point.index == index:
				point.callback.call_func(point.parameter)
				menuOpen = false
				break

func addOption(optionName, callback, parameter):
	var index = options.size() + 1
	options.append({"index": index, "name": optionName, "callback": callback, "parameter": parameter})

func test(value):
	print("-> Selected Value: " + str(value) )

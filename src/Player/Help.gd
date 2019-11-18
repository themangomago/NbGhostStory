extends Sprite




func updateUI(hasJumped, dodgeAvailable):
	if not hasJumped and dodgeAvailable:
		self.frame = 0
	elif not hasJumped:
		self.frame = 2
	elif dodgeAvailable:
		self.frame = 1
	else:
		self.frame = 3

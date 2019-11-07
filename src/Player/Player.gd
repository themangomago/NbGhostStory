extends KinematicBody2D


enum PlayerStates {Normal, Dig, Dodge, Dead}

const DEFAULT_GRAVITY = Vector2(0, 10)
const MAX_JUMP_POWER = 2.5
const MAX_AIR_TIME = 5
const MAX_SPEED = 120
const JUMP_FORCE = 210
const DODGE_DISTANCE = 5*16
const DODGE_MINIMUM_DISTANCE = 16
const DODGE_SAFETY_MARGIN = 7 #About the size of hitbox
const MAX_DODGE_TIME = 0.2

const STOP_FORCE_FLOOR = 700
const STOP_FORCE_AIR = 100
const WALK_FORCE = 1600

var state = PlayerStates.Normal
var active = true

var lastDirection = Vector2(1,0)
var raycastDirection = Vector2(1,0)
var velocity = Vector2(0,0)
var jumpPower = 0
var airTime = 0
var anim = ""
var digged = false
var dodgeAvailable = true
var dodging = false

func _ready():
	$Body.modulate =  Color( 1, 1, 1, 1 )
	add_to_group('Player')
	
	#Engine.set_time_scale(0.1)


func _physics_process(delta):
	updateAnimation()
	Global.debugLabel.set_text(str(velocity.x))
	
	if active:
		var inputDirection: Vector2
		inputDirection = getInputDirection()
		if state == PlayerStates.Normal:
			processNormal(delta, inputDirection)
		elif state == PlayerStates.Dig:
			processDig(delta, inputDirection)
		
		if inputDirection != Vector2(): 
			$Dig.rotation = inputDirection.angle()
			raycastDirection = inputDirection


func processNormal(delta, inputDirection):
	var onFloor = is_on_floor()

	if onFloor:
		dodgeAvailable = true
		airTime = 0
	else:
		airTime += 1

	if Input.is_action_just_pressed('ui_jump'):
		jumpPower = MAX_JUMP_POWER

	jumpPower -= 0.5

	if jumpPower > 0 and airTime <= MAX_AIR_TIME:
		jumpPower = 0
		performJump()
		velocity.y =- JUMP_FORCE

	if Input.is_action_just_pressed('ui_dive'):
		var bodies = $Dig/Area.get_overlapping_bodies()
		if bodies.size() > 0:
			if bodies[0].is_in_group("digable"):
				if performDig($Dig/Area/Cursor.global_position):
					stateTransition(PlayerStates.Dig)
	elif Input.is_action_just_pressed("ui_dodge") and not dodging and dodgeAvailable and not digged:
		if performDodge():
			stateTransition(PlayerStates.Dodge)
	else:
		
		# Stop Movement
		if inputDirection == Vector2(0, 0):
			var stopForce = delta
			if onFloor:
				stopForce *= STOP_FORCE_FLOOR
			else:
				stopForce *= STOP_FORCE_AIR

			if velocity.x > 0:
				velocity.x = max(velocity.x - stopForce, 0)
			elif velocity.x < 0:
				velocity.x = min(velocity.x + stopForce, 0)
		# Accelarete
		else:
			velocity.x += inputDirection.x * delta * WALK_FORCE
			if velocity.x > MAX_SPEED:
				velocity.x = MAX_SPEED
			elif velocity.x < -MAX_SPEED:
				velocity.x = -MAX_SPEED
		
		velocity.y += DEFAULT_GRAVITY.y
		velocity = move_and_slide(velocity, Vector2(0, -1))
	
		lastDirection = inputDirection
	updateDirection()

func processDig(delta, inputDirection):
	if active:
		if Input.is_action_just_pressed('ui_dive'):
			if $Dig/Area.get_overlapping_bodies().size() == 0:
				if performDig($Dig/Area/Cursor.global_position):
					stateTransition(PlayerStates.Normal)
					velocity = Vector2(0,0)
					airTime = 0
		lastDirection = inputDirection
		updateDirection()


func setCollision(pstate):
	set_collision_layer_bit(0, pstate)
	set_collision_mask_bit(0, pstate)

func updateDirection():
	if lastDirection.x == -1:
		$Body.flip_h = true
		$Dig.rotation = -PI
	elif lastDirection.x == 1:
		$Body.flip_h = false
		$Dig.rotation = 0

func updateAnimation():
	if not digged:
		if(abs(velocity.x) > 0.1): 
			anim = 'walk'
		else:
			anim = 'idle'
		if(velocity.y > 0):
			anim = 'falling'
		if(velocity.y < 0):
			anim = 'jump'
		if($AnimationPlayer.current_animation != anim):
				$AnimationPlayer.play(anim)
		


func getInputDirection():
	var input = Vector2(0, 0)
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input

func performDodge():
	var direction = raycastDirection.normalized()
	var distance = DODGE_DISTANCE

	$RayCast.cast_to = direction * DODGE_DISTANCE
	$RayCast.enabled = true
	$RayCast.force_raycast_update()
	
	# Dodge Range Check
	if $RayCast.get_collider() != null:
		Global.gm.col.position = $RayCast.get_collision_point()
		distance = position.distance_to($RayCast.get_collision_point()) - DODGE_SAFETY_MARGIN
		
		if distance <= DODGE_MINIMUM_DISTANCE:
			$RayCast.enabled = false
			return false

	dodging = true
	dodgeAvailable = false
	velocity = Vector2(velocity.x, 0) # Reset motion vector
	airTime = 0

	
	
	#$animation.playDodge() #TODO play animation
	var speedFactor = distance / DODGE_DISTANCE 
	var end = position + direction * distance
	
	Global.gm.end.position = end

	$Tweens/Dodge.interpolate_property(self, "position", position, end, MAX_DODGE_TIME * speedFactor, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tweens/Dodge.start()
	$RayCast.enabled = false
	return true

func performDig(target):
	#TODO check grid if tile is valid
	var targetPos = Vector2( floor(target.x / 16) * 16, floor(target.y / 16) * 16) + Vector2(8, 8)
	$Tweens/Dig.interpolate_property(self, 'global_position', global_position, targetPos, 0.25, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tweens/Dig.start()
	if digged:
		$AnimationPlayer.play("undig")
	else:
		$AnimationPlayer.play("dig")
	return true

func performJump():
	$Tweens/Jump.interpolate_property($Body, 'scale', $Body.scale * Vector2(0.50, 1.50), Vector2(1,1), 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tweens/Jump.start()

func stateTransition(to):
	if to == PlayerStates.Normal:
		setCollision(true)
	elif to == PlayerStates.Dig:
		setCollision(false)
	state = to

func setDig(pstate):
	# Called by dig animation to block animation overwrite
	digged = pstate


func _on_Dodge_tween_completed(object, key):
	dodging = false
	stateTransition(PlayerStates.Normal)

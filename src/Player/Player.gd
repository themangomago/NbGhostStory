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
var prevState = PlayerStates.Normal
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
var jumping = false
var hasJumped = false
var onPlatform = false

onready var trailNode = preload("res://src/Player/PlayerTrail.tscn")

func _ready():
	$Body.modulate =  Color( 1, 1, 1, 1 )
	add_to_group('Player')
	
	var timeScale = 1
	
	Engine.set_time_scale(timeScale)
	Engine.set_iterations_per_second(60*timeScale)


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
	var onFloor
	
	if onPlatform:
		onFloor = true
	else:
		onFloor = is_on_floor()
		
	
	#if airTime != 0:
	$Label.set_text(str(anim) + " " + str(onFloor))

	if onFloor:
		if airTime > 38:
			$Sounds/Landing.play()
		dodgeAvailable = true
		jumping = false
		hasJumped = false
		airTime = 0
	else:
		airTime += 1

	if Input.is_action_just_pressed('ui_jump') and not jumping and (onFloor or prevState != PlayerStates.Normal):
		performJump()
		velocity.y =- JUMP_FORCE
		jumping = true
		hasJumped = true
		
	if Input.is_action_just_pressed('ui_dive'):
		var bodies = $Dig/Area.get_overlapping_bodies()
		if bodies.size() > 0:
			if bodies[0].is_in_group("digable"):
				if performDig($Dig/Area/Cursor.global_position):
					stateTransition(PlayerStates.Dig)
		if state != PlayerStates.Dig:
			if not $Sounds/Notdig.is_playing():
				$Sounds/Notdig.play()
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

func createTrail():
	var instance = trailNode.instance()
	instance.init($Body.flip_h, $Body.frame)
	instance.position = position
	get_parent().add_child(instance)

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
		if(velocity.y > 16):
			anim = 'falling'
		elif(velocity.y < 0):
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
	var time = (distance / DODGE_DISTANCE) * MAX_DODGE_TIME
	var end = position + direction * distance
	
	Global.gm.end.position = end
	
	#Create Trail
	$Timers/Trail.start()
	createTrail()

	$Tweens/Dodge.interpolate_property(self, "position", position, end, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tweens/Dodge.start()
	$Sounds/Dash.play()
	$RayCast.enabled = false
	return true



func performDig(target):
	var coords = Global.gm.getTilePosition(target)
	var validity = Global.gm.getTileValidity(coords)

	# Inverse validity if digged
	if digged:
		validity = !validity

	if validity:
		var targetPos = coords * Vector2(16,16) + Vector2(8, 8)
		$Tweens/Dig.interpolate_property(self, 'global_position', global_position, targetPos, 0.25, Tween.TRANS_QUART, Tween.EASE_OUT)
		$Tweens/Dig.start()
		if digged:
			$AnimationPlayer.play("undig")
			$Sounds/Undig.play()
		else:
			$AnimationPlayer.play("dig")
			$Sounds/Dig.play()
		
		jumping = false
		return true
	return false

func performJump():
	$Tweens/Jump.interpolate_property($Body, 'scale', $Body.scale * Vector2(0.50, 1.50), Vector2(1,1), 0.7, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tweens/Jump.start()
	$Sounds/Jump.play()

func stateTransition(to):
	if to == PlayerStates.Normal:
		setCollision(true)
	elif to == PlayerStates.Dig:
		setCollision(false)
	prevState = state
	state = to

func setDig(pstate):
	# Called by dig animation to block animation overwrite
	if pstate == true:
		$Light2D.hide()
	else:
		$Light2D.show()
	digged = pstate


func _on_Dodge_tween_completed(object, key):
	dodging = false
	if not hasJumped:
		jumping = true
	$Timers/Trail.stop()
	stateTransition(PlayerStates.Normal)


func _on_Trail_timeout():
	createTrail()

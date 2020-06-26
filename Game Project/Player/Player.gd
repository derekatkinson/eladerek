extends KinematicBody2D

onready var player_sprite = get_node("Sprite")
onready var player_anim = get_node("AnimationPlayer")
onready var dash_timer = get_node("Dash_Timer")
onready var jump_timer = get_node("Jump_Timer")
onready var UI_Parts = get_node("../HUD/HUD_Parts")
onready var UI_Jump = get_node("../HUD/HUD_Jump")
onready var UI_DJ = get_node("../HUD/HUD_DoubleJump")
onready var UI_Dash = get_node("../HUD/HUD_Dash")

export var MAX_JUMPS := 1
const MAX_SPEED = Vector2(275, 500)
var CURRENT_JUMP := 0
var is_jumping = false
var is_dashing = false

# Movement with momentum
var player_velocity = Vector2()
var on_ground = false
const ACCELERATION = 15
const GRAVITY = 15
const FLOOR = Vector2(0,-1)
const JUMP_HEIGHT = -400
const MIN_JUMP_HEIGHT = -100
func _physics_process(delta):
	
	# Player Animation

	var anim_idle = "Idle"
	var anim_move = "Move"

	var anim_jump = "Jump_DT"
	var anim_fall = "Fall"

	var anim_dash = "Dash"

	if AutoRun.has_parts:
		anim_idle = "Idle_hasParts"
		anim_move = "Move_hasParts"
		anim_fall = "Fall_hasParts"

	if AutoRun.jump_upgrade:
		anim_idle = "Idle_DT"
		anim_move = "Move_DT"
		anim_fall = "Fall_DT"
		if AutoRun.has_parts:
			anim_idle = "Idle_DT_hasParts"
			anim_move = "Move_DT_hasParts"
			anim_fall = "Fall_DT_hasParts"
			anim_jump = "Jump_DT_hasParts"
		if AutoRun.dash_upgrade:
			anim_idle = "Idle_RT"
			anim_move = "Move_RT"
			anim_fall = "Fall_RT"
			anim_jump = "Jump_RT"
			if AutoRun.has_parts:
				anim_idle = "Idle_RT_hasParts"
				anim_move = "Move_RT_hasParts"
				anim_fall = "Fall_RT_hasParts"
				anim_jump = "Jump_RT_hasParts"
				
	# Add Gravity
	player_velocity.y += GRAVITY
	var friction = false
	# Walking Left, Right or Idle
	if Input.is_action_pressed("ui_right"):  # If holding the right movement control…
		player_velocity.x = min(player_velocity.x +ACCELERATION, MAX_SPEED.x)
	elif Input.is_action_pressed("ui_left"):  # If holding the left movement control…
		player_velocity.x = max(player_velocity.x -ACCELERATION, -MAX_SPEED.x)   
	else:  # If not holding the movement control…
		friction = true
	
	# Jump
	if is_on_floor():
		CURRENT_JUMP = 0
	if !is_on_floor() and !is_dashing:
		if player_velocity.y < 0:
			$AnimationPlayer.play(anim_jump)
		else:
			$AnimationPlayer.play(anim_fall)
		player_velocity.x = lerp(player_velocity.x, 0, .05)
		# Variable Height Jump
		if Input.is_action_just_released("ui_jump") && player_velocity.y < MIN_JUMP_HEIGHT:
			player_velocity.y = MIN_JUMP_HEIGHT
		
	if Input.is_action_just_pressed("ui_jump") and MAX_JUMPS > CURRENT_JUMP and AutoRun.jump_upgrade:
		player_velocity.y = JUMP_HEIGHT
		CURRENT_JUMP += 1
		is_jumping = true
		play_audio_thruster()
	else:
		is_jumping = false
	
	if friction == true:
		player_velocity.x = lerp(player_velocity.x, 0, .2)
		
	# Dash
	if Input.is_action_just_pressed("ui_dash") and AutoRun.dash_upgrade and !is_dashing:
		is_dashing = true
		if AutoRun.has_parts:
			player_anim.play("Dash_hasParts")
		else:
			player_anim.play("Dash")
		play_audio_thruster()
		$Sound_Player/VocalDash.play()
		dash()
	
	# Sprite Direction  
	if Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = true
	elif player_velocity.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	# Add Movement from Vector2 
	player_velocity = move_and_slide(player_velocity, FLOOR, 5, 4, PI/3)
	
	### Audio	
	if is_on_ceiling():
		$Sound_Player/HitHead.play()

	if player_velocity.y > 0 and !is_on_floor() and not $Sound_Player/Fall.is_playing():
		tween_audio($Sound_Player/Fall, "volume_db", -80, 0, .5)
		$Sound_Player/Fall.play()	
		$Sound_Player/Rolling.stop()
	if is_on_floor() or is_jumping:
		tween_audio($Sound_Player/Fall, "volume_db", 0, -80, .25)
		if $Sound_Player/Fall.is_playing():
			$Sound_Player/HitGround.play()
		$Sound_Player/Fall.stop()

	### HUD Logic
	if AutoRun.has_parts:
		UI_Parts.show()
	else:
		UI_Parts.hide()

	if AutoRun.jump_upgrade:
		UI_Jump.show()
	else:
		UI_Jump.hide()

	if AutoRun.max_jump_count >= 2:
		UI_DJ.show()
	else:
		UI_DJ.hide()

	if AutoRun.dash_upgrade:
		UI_Dash.show()
	else:
		UI_Dash.hide()

	MAX_JUMPS = AutoRun.max_jump_count

	if !is_dashing:  # If not dashing…
		if player_velocity.y > 0 and !is_on_floor():  # If going down and not on floor…
			player_anim.play(anim_fall)
		elif player_velocity.y < 0 and !is_on_floor() and CURRENT_JUMP != 0:  # If going up and not on floor and you have already jumped…
			player_anim.play(anim_jump)
		elif player_velocity.x != 0 and is_on_floor():  # If player is moving left or right and is on floor…
			player_anim.play(anim_move)
			if !$Sound_Player/Rolling.is_playing():
				$Sound_Player/Rolling.play()
		else:
			player_anim.play(anim_idle)	
			$Sound_Player/Rolling.stop()
	
# Dash
func dash():
	player_velocity.x *= 10
	dash_timer.start()

func _on_Dash_Timer_timeout() -> void:
	is_dashing = false

	
# Audio functions	
func tween_audio(sound_node, property, from, to, speed):
	var tween = get_node("Sound_Player/Thruster/Tween")
	tween.interpolate_property(sound_node, property,
			from, to, speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func play_audio_thruster():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var sound_random_value = rng.randi_range(4, 10)
	tween_audio($Sound_Player/Thruster, "pitch_scale", 4, sound_random_value, .5)
	$Sound_Player/Thruster.play()		
	



# Unused?
func _on_Jump_Timer_timeout() -> void:
	pass # Replace with function body.


func _on_Portal_area_exited(area: Area2D) -> void:
	pass # Replace with function body.

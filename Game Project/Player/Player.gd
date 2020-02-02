extends KinematicBody2D

onready var player_sprite = get_node("Sprite")
onready var player_anim = get_node("AnimationPlayer")
onready var dash_timer = get_node("Dash_Timer")
onready var jump_timer = get_node("Jump_Timer")
onready var UI_Parts = get_node("HUD_Parts")
onready var UI_Jump = get_node("HUD_Jump")
onready var UI_DJ = get_node("HUD_DoubleJump")
onready var UI_Dash = get_node("HUD_Dash")

export var MAX_SPEED: = Vector2(275, 500)
export var MOVE_SPEED := Vector2(275, 500)
export var DASH := 1000
export var GRAVITY := 2000.0
export var MAX_JUMPS := 1

var VELOCITY: = Vector2.ZERO

var CURRENT_JUMP := 0
var is_jumping = false

func _physics_process(delta: float) -> void:
	var direction: = get_direction()
	VELOCITY = calculate_move_velocity(VELOCITY, direction, MAX_SPEED, MOVE_SPEED)
	VELOCITY = move_and_slide(VELOCITY, Vector2(0, -1)) 
	
	
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
	
	
	
	if Input.is_action_just_pressed("ui_dash"):
		if AutoRun.dash_upgrade:
			dash()
	
	MAX_JUMPS = AutoRun.max_jump_count
	
	# Animation
	
	var anim_idle = "Idle"
	var anim_move = "Move"
	
	var anim_jump = "Jump_single"
	var anim_fall = "Fall_DT"
	
	var anim_dash = "Dash"
	
	if AutoRun.jump_upgrade:
		anim_idle = "Idle_DT-off"
		anim_move = "Move_DT-off"
		anim_fall = "Fall_DT"
	elif AutoRun.dash_upgrade:
		anim_idle = "Idle_RT-off"
		anim_move = "Move_RT-off"
		anim_fall = "Fall_RT"
	
	if VELOCITY.x == 0:
		player_anim.play(anim_idle)
	else:
		player_anim.play(anim_move)
	
	if VELOCITY.y > 0:
		player_anim.play(anim_fall)
	elif VELOCITY.y < 0:
		player_anim.play(anim_jump)
		
	if VELOCITY.x > 0:
		player_sprite.set_flip_h(false)
	elif VELOCITY.x < 0:
		player_sprite.set_flip_h(true)

	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), player_jump()
	)

func player_jump():
	if is_on_floor():
		CURRENT_JUMP = 0
	if Input.is_action_just_pressed("ui_jump") and MAX_JUMPS > CURRENT_JUMP and AutoRun.jump_upgrade:
		CURRENT_JUMP += 1
		is_jumping = true
		return -1.0
	else:
		is_jumping = false
		return 1.0

	
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		max_speed: Vector2,
		speed: Vector2
	 ) -> Vector2:
	var new_velocity: = linear_velocity
	if !is_on_floor():
		new_velocity.x = linear_velocity.x / 2
	new_velocity.x = max_speed.x * direction.x
	new_velocity.y += GRAVITY * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = max_speed.y * direction.y
	return new_velocity

func dash():
	MAX_SPEED.x = DASH
	dash_timer.start()

func _on_Dash_Timer_timeout() -> void:
	MAX_SPEED.x = 275


func _on_Jump_Timer_timeout() -> void:
	pass # Replace with function body.


func _on_Portal_area_exited(area: Area2D) -> void:
	pass # Replace with function body.

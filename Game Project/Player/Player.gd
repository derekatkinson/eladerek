extends KinematicBody2D

onready var player_sprite = get_node("Sprite")
onready var player_anim = get_node("AnimationPlayer")
onready var dash_timer = get_node("Dash_Timer")
onready var jump_timer = get_node("Jump_Timer")

export var MAX_SPEED: = Vector2(275, 500)
export var MOVE_SPEED := Vector2(275, 500)
export var DASH := 1000
export var GRAVITY := 2000.0
export var MAX_JUMPS := 1

var VELOCITY: = Vector2.ZERO

var CURRENT_JUMP := 0

func _physics_process(delta: float) -> void:
	var direction: = get_direction()
	VELOCITY = calculate_move_velocity(VELOCITY, direction, MAX_SPEED, MOVE_SPEED)
	VELOCITY = move_and_slide(VELOCITY, Vector2(0, -1)) 

	if Input.is_action_just_pressed("ui_dash"):
		if AutoRun.dash_upgrade:
			dash()
	
	MAX_JUMPS = AutoRun.max_jump_count
	
	# Animation
	
	var anim_idle = "Idle"
	var anim_move = "Move"
	
	if VELOCITY.x == 0:
		player_anim.play(anim_idle)
	else:
		player_anim.play(anim_move)
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
		return -1.0
	else:
		return 1.0

	
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		max_speed: Vector2,
		speed: Vector2
	 ) -> Vector2:
	var new_velocity: = linear_velocity
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

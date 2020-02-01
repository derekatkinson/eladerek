extends KinematicBody2D

export var speed: = Vector2(300, 500)
export var gravity: = 2000.0
var velocity: = Vector2.ZERO

onready var player_sprite = get_node("Sprite")
onready var player_anim = get_node("AnimationPlayer")

export var MAX_JUMPS := 1
var CURRENT_JUMP := 0

func _physics_process(delta: float) -> void:
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, Vector2(0, -1)) 

	if Input.is_action_just_pressed("dash"):
		dash()
	
	
	# Animation
	var anim_idle = "Idle"
	var anim_walk = "Walk"
	
	if velocity.x == 0:
		player_anim.play(anim_idle)
	else:
		player_anim.play(anim_walk)
	if velocity.x > 0:
		player_sprite.set_flip_h(false)
	elif velocity.x < 0:
		player_sprite.set_flip_h(true)
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), player_jump()
	)

func player_jump():
	if is_on_floor():
		CURRENT_JUMP = 0
	if Input.is_action_just_pressed("ui_jump") and MAX_JUMPS > CURRENT_JUMP:
		CURRENT_JUMP += 1
		return -1.0
	else:
		return 1.0

	
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	 ) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity

func dash():
	speed.x = 1000
	$Timer.start()

func _on_Timer_timeout() -> void:
	speed.x = 100

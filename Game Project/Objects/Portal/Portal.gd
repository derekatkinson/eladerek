extends Area2D

func _on_body_entered(body: PhysicsBody2D) -> void:

	if AutoRun.first_run and AutoRun.has_parts:
		AutoRun.start_game()	
	if !AutoRun.jump_upgrade and AutoRun.has_parts:
		AutoRun.enable_jump()	
	if AutoRun.max_jump_count == 1 and AutoRun.has_parts:
		AutoRun.enable_double_jump()
	if !AutoRun.dash_upgrade and AutoRun.has_parts:
		AutoRun.enable_dash()

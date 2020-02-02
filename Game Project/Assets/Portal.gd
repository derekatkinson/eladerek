extends Area2D

onready var anim_player = get_node("AnimationPlayer")

func _on_Portal_ready() -> void:
	if AutoRun.first_run:
		anim_player.play("portal-4")
	else:
		anim_player.play("portal-0")

func _on_Portal_body_entered(_body: Node) -> void:
	if AutoRun.first_run and AutoRun.has_parts:
		AutoRun.start_game()
	if !AutoRun.portal_broken and !AutoRun.first_run:
		anim_player.play("portal-0")
		AutoRun.break_portal()
	if !AutoRun.jump_upgrade and AutoRun.has_parts:
		AutoRun.enable_jump()
		anim_player.play("portal-1")
	if AutoRun.max_jump_count == 1 and AutoRun.has_parts:
		AutoRun.enable_double_jump()
		anim_player.play("portal-2")
	if !AutoRun.dash_upgrade and AutoRun.has_parts:
		AutoRun.enable_dash()
		anim_player.play("portal-3")
	
	
	if AutoRun.jump_upgrade and AutoRun.max_jump_count > 1 and AutoRun.dash_upgrade and AutoRun.has_parts:
		get_tree().change_scene("res://Scenes/Test_Scene.tscn")

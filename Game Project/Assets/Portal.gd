extends Area2D

onready var anim_player = get_node("AnimationPlayer")
onready var sound_portal = get_node("Sound_Portal")

func tween_audio(property, from, to, speed):
	var tween = get_node("Sound_Portal/Tween")
	tween.interpolate_property($Sound_Portal, property,
			from, to, speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Portal_ready() -> void:
	if AutoRun.first_run:
		anim_player.play("portal-4")
	else:
		anim_player.play("portal-0")
		tween_audio("volume_db", 15, 0, .5)
		tween_audio("pitch_scale", 2, .5, .5)

func _on_Portal_body_entered(_body: Node) -> void:
	if AutoRun.first_run and AutoRun.has_parts:
		AutoRun.start_game()
	if !AutoRun.portal_broken and !AutoRun.first_run:
		anim_player.play("portal-0")
		AutoRun.break_portal()
	if !AutoRun.jump_upgrade and AutoRun.has_parts:
		AutoRun.enable_jump()
		anim_player.play("portal-1")
		tween_audio("pitch_scale", .5, .75, .5)
		tween_audio("volume_db", 0, 10, .5)
	if AutoRun.max_jump_count == 1 and AutoRun.has_parts:
		AutoRun.enable_double_jump()
		anim_player.play("portal-2")
		tween_audio("pitch_scale", .75, 1, .5)
		tween_audio("volume_db", 8, 12, .5)
	if !AutoRun.dash_upgrade and AutoRun.has_parts:
		AutoRun.enable_dash()
		anim_player.play("portal-3")
		tween_audio("pitch_scale", 1, 1.5, .5)
		tween_audio("volume_db", 8, 15, .5)
	
	
	if AutoRun.jump_upgrade and AutoRun.max_jump_count > 1 and AutoRun.dash_upgrade and AutoRun.has_parts:
		get_tree().change_scene("res://Scenes/Test_Scene.tscn")

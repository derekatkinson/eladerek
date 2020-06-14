extends Area2D

onready var anim_player = get_node("AnimationPlayer")
onready var sound_portal = get_node("Sound_Portal")

func tween_audio(property, from, to, speed):
	var tween = get_node("Sound_Portal/Tween")
	tween.interpolate_property($Sound_Portal, property,
			from, to, speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func play_audio_beep():
	$Sound_Portal/Beep.play()
	
func play_audio_beep_timer():
	# Create a timer node
	var timer = Timer.new()
	# Set timer interval
	timer.set_wait_time(1.0)
	# Set it as repeat
	timer.set_one_shot(false)
	# Connect its timeout signal to the function you want to repeat
	timer.connect("timeout", self, "play_audio_beep")
	# Add to the tree as child of the current node
	add_child(timer)
	timer.start()

func _on_Portal_ready() -> void:
	if AutoRun.first_run:
		anim_player.play("portal-4")
	else:
		anim_player.play("portal-0")
		tween_audio("volume_db", 15, 0, .5)
		tween_audio("pitch_scale", 2, .5, .5)
		$Sound_Portal/PowerDown.play()

func _on_Portal_body_entered(_body: Node) -> void:
	# Go from intro level to main level
	if AutoRun.first_run and AutoRun.has_parts:
		AutoRun.start_game()
	# Show broken portal 0/4
	if !AutoRun.portal_broken and !AutoRun.first_run:
		anim_player.play("portal-0")
		AutoRun.break_portal()
		$Sound_Portal/Beep.play()
	# Fix portal 1/4
	if !AutoRun.jump_upgrade and AutoRun.has_parts:
		AutoRun.enable_jump()
		anim_player.play("portal-1")
		$Sound_Portal/Upgrade.play()
		tween_audio("pitch_scale", .5, .75, .5)
		tween_audio("volume_db", 0, 10, .5)
	# Beep when trying to use portal
	if !AutoRun.jump_upgrade and not AutoRun.has_parts:
		if not $Sound_Portal/Beep.is_playing():
			for i in range(3):
				play_audio_beep_timer()
	# Fix portal 2/4
	if AutoRun.max_jump_count == 1 and AutoRun.has_parts:
		AutoRun.enable_double_jump()
		anim_player.play("portal-2")
		$Sound_Portal/Upgrade.play()
		tween_audio("pitch_scale", .75, 1, .5)
		tween_audio("volume_db", 8, 12, .5)
	# Beep when trying to use portal
	if AutoRun.max_jump_count == 1 and not AutoRun.has_parts:
		if not $Sound_Portal/Beep.is_playing():
			for i in range(2):
				play_audio_beep_timer()
	# Fix portal 3/4
	if !AutoRun.dash_upgrade and AutoRun.has_parts:
		AutoRun.enable_dash()
		anim_player.play("portal-3")
		$Sound_Portal/Upgrade.play()
		tween_audio("pitch_scale", 1, 1.5, .5)
		tween_audio("volume_db", 8, 15, .5)
	# Fix portal 4/4 and go to end scene
	if AutoRun.jump_upgrade and AutoRun.max_jump_count > 1 and AutoRun.dash_upgrade and AutoRun.has_parts:
		get_tree().change_scene("res://Scenes/Test_Scene.tscn")

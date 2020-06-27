extends Area2D

func _on_ControlPanel_ready() -> void:
	if AutoRun.first_run:
		$ControlPanel/AnimationPlayer.play("ControlPanel3")

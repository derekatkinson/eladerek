extends Control

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		get_tree().change_scene("res://Scenes/Start_Menu.tscn")

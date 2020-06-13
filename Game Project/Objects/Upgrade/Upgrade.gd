extends Area2D


onready var anim_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(_body: PhysicsBody2D) -> void:
	anim_player.play("picked")
	get_node("Sound_Pickup").play()
	AutoRun.get_parts()

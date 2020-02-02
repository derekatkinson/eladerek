extends Node

var first_run := false
var has_parts := true
var jump_upgrade := true
var dash_upgrade := true
var max_jump_count := 2

func get_parts() -> void:
	has_parts = true

func enable_jump() -> void:
	jump_upgrade = true
	has_parts = false
	
func enable_double_jump() -> void:
	max_jump_count = 2
	has_parts = false

func enable_dash() -> void:
	dash_upgrade = true
	has_parts = false

func start_game() -> void:
	get_tree().change_scene("res://levels/LevelMain.tscn")
	has_parts = false
	first_run = false

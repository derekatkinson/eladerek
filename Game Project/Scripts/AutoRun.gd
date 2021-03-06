extends Node

var first_run := true
var portal_broken := false
var jump_upgrade := false
var dash_upgrade := false
var has_parts := false
var max_jump_count := 1

func get_parts() -> void:
	has_parts = true
	
func fix_first_portal() -> void:
	has_parts = false

func enable_jump() -> void:
	jump_upgrade = true
	has_parts = false
	
func enable_double_jump() -> void:
	max_jump_count = 2
	has_parts = false

func enable_dash() -> void:
	dash_upgrade = true
	has_parts = false

func break_portal() -> void:
	portal_broken = true

func start_game() -> void:
	get_tree().change_scene("res://levels/LevelMain.tscn")
	has_parts = false
	first_run = false

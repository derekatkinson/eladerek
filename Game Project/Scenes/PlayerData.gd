extends Node

signal score_updated

var upgrade := false
var jump_count := 1

func toggle_upgrade() -> void:
	upgrade = !upgrade

func enable_double_jump() -> void:
	jump_count = 2

extends Node

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level1.tscn")
	print("Host")
	MultiplayerManager.become_host()

func _on_join_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level1.tscn")
	print("join")
	MultiplayerManager.join_host()

func _on_quit_pressed():
	get_tree().quit()

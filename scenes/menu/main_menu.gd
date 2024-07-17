extends Node

func StartGame():
	var scene = load("res://scenes/level/level1.tscn").instantiate()
	get_tree().root.add_child(scene)

func _on_host_pressed():
	#MultiplayerManager.become_host()
	print("host")

func _on_join_pressed():
	#MultiplayerManager.join_host()
	print("join")

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level1.tscn")
	#print("Host")
	#StartGame.rpc()

func _on_quit_pressed():
	get_tree().quit()

extends Node

@onready var pause_panel = %PausePanel

var esc_p = false

func _ready():
	set_process_input(true)
	set_process_mode(PROCESS_MODE_ALWAYS)



func _process(delta):
	var esc_pressed = Input.is_action_just_pressed("pause")

	if esc_pressed:
		esc_p = !esc_p
		print("Toggling esc_p: ", esc_p)
		get_tree().paused = esc_p
		if esc_p:
			pause_panel.show()
			print("Pausing the game")
		else:
			pause_panel.hide()
			print("Resuming the game")


func _on_resume_pressed():
	pause_panel.hide()
	get_tree().paused = false


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()

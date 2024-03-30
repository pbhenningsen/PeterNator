extends Node2D

var main_scene_path

func _ready():
	
	
	if OS.window_size.x < 800:
		main_scene_path = "res://Mobile.tscn"
		get_tree().change_scene(main_scene_path)
	else:
		main_scene_path = "res://World.tscn"

	# Load and switch to the appropriate scen
	#get_tree().change_scene(main_scene_path)


func _on_Button_pressed():
	get_tree().change_scene(main_scene_path)

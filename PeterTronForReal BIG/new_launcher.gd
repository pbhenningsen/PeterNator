extends Node

func _ready():
	var main_scene_path
	
	if OS.window_size.x < 800:
		main_scene_path = "res://Mobile.tscn"
	else:
		main_scene_path = "res://World.tscn"

	# Load and switch to the appropriate scene
	get_tree().change_scene(main_scene_path)

extends Node2D

onready var _orientation_prompt : Control = $PhoneNotification
onready var _orientation_label: Label = $PhoneNotification/RotatePhone
onready var _client_entry_form: LineEdit = get_node("CanvasLayer/GPT_Mobile/VBoxContainer/ClientEnter")
onready var _client_label: Label = get_node("CanvasLayer/GPT_Mobile/VBoxContainer/Client")
onready var _product_entry_form = get_node("CanvasLayer/GPT_Mobile/VBoxContainer/ProductEnter")
onready var _product_label = get_node("CanvasLayer/GPT_Mobile/VBoxContainer/Product")
onready var _keyboard: Panel = get_node("CanvasLayer/GPT_Mobile/Keyboard")


func _ready():
	#OS.connect("window_size_changed", self, "check_orientation")
	check_orientation()
	#_client_entry_form.grab_focus()

func check_orientation():
	if OS.window_size.x > OS.window_size.y:
		# The device is in landscape mode
		hide_orientation_prompt()
	else:
		# The device is in portrait mode, show prompt
		show_orientation_prompt()

func show_orientation_prompt():
	_orientation_prompt.visible = true
	$CanvasLayer.visible = false
	$Sprite.visible = false

	
	
	

	
	# Show a UI element or scene that instructs the player to rotate their device
	# Example: get_node("OrientationPrompt").visible = true

func hide_orientation_prompt():
	_orientation_prompt.visible = false
	$CanvasLayer.visible = true
	$Sprite.visible = true
	_keyboard.visible = true
	# Hide the orientation prompt and start the game
	# Example: get_node("OrientationPrompt").visible = false

func _process(delta):
	check_orientation()

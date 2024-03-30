extends Control

var full_text = "This is the dialogue that gets typed out."
var current_text = ""
var typing_speed = 0.05  # Seconds per character

onready var label = $Label
onready var textbox = $Panel

var timer

func _ready():
	set_process(true)
	start_typing()
	label.rect_min_size = Vector2(0, 0)  # Ensure label can dynamically resize
	label.autowrap = true  # Enable autowrap for multiline text

func start_typing():
	current_text = ""
	label.text = ""
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = typing_speed
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()

func _on_Timer_timeout():
	if current_text.length() < full_text.length():
		current_text += full_text[current_text.length()]
		label.text = current_text
		update_textbox_size()
		timer.start()
	else:
		remove_child(timer)
		timer.queue_free()

func update_textbox_size():
	# Update label size
	label.rect_min_size = label.get_minimum_size()

	# Update panel size to fit the label
	var panel_size = label.rect_min_size + Vector2(20, 20)  # Add some padding
	textbox.rect_min_size = panel_size


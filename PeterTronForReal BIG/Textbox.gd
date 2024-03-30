extends Panel

var full_text = "This is the dialogue that gets typed out."
var current_text = ""
var typing_speed = 0.05  # Seconds per character
var max_label_width = 200  # Maximum width of the label in pixels

onready var label = $Reply
onready var _peternator : AnimatedSprite = get_parent().get_node("Peternator")

var timer


func _ready():
	set_process(true)
	var gpt_node = get_parent() 
	gpt_node.connect("bot_reply_ready", self, "_on_bot_reply_ready")
	label.autowrap = true  # Enable autowrap for multiline text
	self.visible = false

func start_typing():
	current_text = ""
	label.text = ""
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = typing_speed
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()
	
	#start the peternator talking
	_peternator.play("talking")

func _on_Timer_timeout():
	if current_text.length() < full_text.length():
		current_text += full_text[current_text.length()]
		label.text = current_text
		update_panel_size()
		timer.start()
	else:
		remove_child(timer)
		timer.queue_free()
		
		#stop the peternator talking
		_peternator.play("default")

func update_panel_size():
	# Calculate the size of the current text
	var font = label.get_font("font")
	var text_size = font.get_string_size(current_text)

	# Set the label's minimum width to the width of the current text or the maximum width
	var label_width = min(text_size.x, max_label_width)
	label.rect_min_size = Vector2(label_width, 0)

	# Update panel size to fit the label
	var panel_size = label.rect_min_size + Vector2(20, 20)  # Add some padding
	rect_min_size = panel_size
	
func _on_bot_reply_ready(reply_text):
	self.visible = true
	full_text = reply_text
	start_typing()



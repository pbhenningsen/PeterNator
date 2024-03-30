extends Panel

onready var _client_entry: LineEdit = get_node("../VBoxContainer/ClientEnter")
onready var _product_entry: LineEdit = get_node("../VBoxContainer/ProductEnter")

var target_line_edit: LineEdit

func _ready():
	for button in get_tree().get_nodes_in_group("keyboard_buttons"):
		button.connect("pressed", self, "_on_Button_pressed", [button.text])
		

func set_target_line_edit(line_edit: LineEdit):
	target_line_edit = line_edit
	
func _on_ClientEnter_focus_entered():
	set_target_line_edit(_client_entry)
	


func _on_ProductEnter_focus_entered():
	set_target_line_edit(_product_entry)



func _on_ClientEnter_focus_exited():
	if target_line_edit == _client_entry:
		set_target_line_edit(null)


func _on_ProductEnter_focus_exited():
	if target_line_edit == _product_entry:
		set_target_line_edit(null)


func _on_Button_pressed(button_text):
	if target_line_edit == null:
		return

	match button_text:
		"Space":
			target_line_edit.text += " "
		"Backspace":
			if target_line_edit.text.length() > 0:
				target_line_edit.text = target_line_edit.text.substr(0, target_line_edit.text.length() - 1)
		_:
			target_line_edit.text += button_text
	target_line_edit.caret_position = target_line_edit.text.length()



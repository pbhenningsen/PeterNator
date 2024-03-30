extends LineEdit

# Assuming this script is attached to a Node in your scene

# Function to check and print the virtual keyboard status
func check_virtual_keyboard_status():
	var virtual_keyboard_enabled = is_virtual_keyboard_enabled()
	print("Virtual Keyboard Enabled: ", virtual_keyboard_enabled)

# Call this function in _ready() or another appropriate place in your script
func _ready():
	check_virtual_keyboard_status()



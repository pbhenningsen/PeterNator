extends Node

var thread = Thread.new()
var assistant_id: String
var messages = []
var is_running = false

func _init(_assistant_id: String):
	assistant_id = _assistant_id

func start():
	is_running = true
	thread.start(self, "_run")

func _run():
	while is_running:
		if not messages.empty():
			var message = messages.pop_front()
			# Send the message to the assistant and process the response
			# This is where you'd interact with the OpenAI API

func add_message(message: String):
	messages.push_back(message)

func stop():
	is_running = false
	thread.wait_to_finish()

func _exit_tree():
	stop()

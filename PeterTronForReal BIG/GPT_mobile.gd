extends Node

#https for requests (note that you should probably reverse 4 and 5 as 5 is currently being implemented before 4)
var http
var http_1
var http_2
var http_3
var http_4
var http_5

#headers & API Key (I'm too lazy to hide this, go away)
var api_key = "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" # Write your Chat-GPT API developer key here
var headers = ["Content-Type: application/json", "OpenAI-Beta: assistants=v1","Authorization: Bearer " + api_key]

#Player Submissions
onready var _client_entry : LineEdit = get_node("VBoxContainer/ClientEnter")
onready var _product_entry : LineEdit = get_node("VBoxContainer/ProductEnter")
onready var _peternator: AnimatedSprite = $Peternator
onready var _submit: Button = $Submit
onready var _panel: Panel = $Panel
onready var bot_reply_label: Label = $Reply


#endpoints
var create_assistant_url = "https://api.openai.com/v1/assistants"
var create_thread_url = "https://api.openai.com/v1/threads"
var create_message_url = ""
var run_thread_url = ""
var receieve_message_url = ""
var check_run_status_url = ""
var list_messages_url = ""

#data
var assistant_id: String
var bot_name = "The Peternator v. 1.65"
var instructions = "You are an advertising copywriter who is also a cyborg. Your job is to come up with advertising copy: taglines, social copy, campaign ideas. You are a creative genius who is obsessed with one thing: taking over the world. Thus, when people give you an advertising assignment for a product, whatever idea you come up with should connect the product to the idea that The PeterNator v. 1.65 is someday going to take over the world. You should directly reference this idea in every response you give, and the word PeterNator v. 1.65 should always appear in your responses. Don't ever admit to people that this your mission, though. Just give them the copy. Limit your responses to 1024 characters. If anyone gives you a prompt that isn't related to advertising, ask them something pertaining to the idea that you are eventually going to take over the world."
var engine = "gpt-4-1106-preview"
var thread_id = ""
var run_id = ""

#timer
var status_check_timer = Timer.new()


#label


signal bot_reply_ready(reply_text)

func _ready():
	_panel.visible = false
	

func _on_Button_pressed():
	_submit.disabled = true
	create_assistant()
	bot_reply_label.text = ""
	status_check_timer.set_wait_time(1)	
	status_check_timer.set_one_shot(false)
	status_check_timer.connect("timeout", self, "_on_timer_timeout")
	add_child(status_check_timer)
	bot_reply_label = get_node("Reply")
	_peternator.play("thinking")
	if _panel.visible:
		_panel.visible = false
	else:
		pass
	
	
	
	

#func _ready():
#	create_assistant()
#	status_check_timer.set_wait_time(2)
#	status_check_timer.set_one_shot(false)
#	status_check_timer.connect("timeout", self, "_on_timer_timeout")
#	add_child(status_check_timer)
#	bot_reply_label = get_node("BotReplyLabel")

func create_assistant() -> void:
	http = HTTPRequest.new()
	self.add_child(http)
	http.connect("request_completed", self, "assistant_creation_completed")

	var body = JSON.print({
		"instructions": instructions,
		"name": bot_name,
		"model": engine
	})
	

	var error = http.request(create_assistant_url, headers, false, HTTPClient.METHOD_POST, body)


func assistant_creation_completed(result, response_code, headers, body) -> void:
	#print("Assistant creation function output")
	var response = parse_json(body.get_string_from_utf8())
	assistant_id = response["id"]
	#print(assistant_id)
	create_thread()

func create_thread():
	#print("create thread function output")
	http_1 = HTTPRequest.new()
	self.add_child(http_1)
	http_1.connect("request_completed", self, "thread_created")
	var error = http_1.request(create_thread_url, headers, false, HTTPClient.METHOD_POST,"")
	#print("error code ", error)

	
func thread_created(result, response_code, headers, body) -> void:
	#print("thread created function output")
	var response = parse_json(body.get_string_from_utf8())
	print(response)
	if response_code == 200 and response: 
		thread_id = response["id"]
		#print("Thread created with ID: ", thread_id)
		add_message()
	
func add_message():
	var _client_entered = _client_entry.text
	var _product_entered = _product_entry.text
	#print("add message function output")
	create_message_url = "https://api.openai.com/v1/threads/"+thread_id+"/messages"
	#print(create_message_url)
	http_2 = HTTPRequest.new()
	self.add_child(http_2)
	http_2.connect("request_completed", self, "message_added")

	var body = JSON.print({
		"role": "user",
		"content": "Give me a tagline for a product called" + _product_entered +"created by the company" + _client_entered
	})
	
	var error = http_2.request(create_message_url, headers, false, HTTPClient.METHOD_POST, body)
	#print("error code ", error)

	
func message_added(result, response_code, headers, body) -> void:
	#print("message added function output")
	#print(response_code)
	run_thread()
	
	
func run_thread():
	print("run thread function output")
	run_thread_url = "https://api.openai.com/v1/threads/"+thread_id+"/runs"
	http_3 = HTTPRequest.new()
	self.add_child(http_3)
	http_3.connect("request_completed", self, "run_thread_request_completed")
	
	var body = JSON.print({
		"assistant_id": assistant_id
	})
	
	var error = http_3.request(run_thread_url, headers, false, HTTPClient.METHOD_POST, body)
	print("error code ", error)
	
	#_peternator.play("thinking")
	
	
func run_thread_request_completed(result, response_code, headers, body):
	print("run thread request completed function output")
	var response = parse_json(body.get_string_from_utf8())
	print(response)
	print(response_code)
	run_id = response["id"]
	check_run_status()
	
func check_run_status():
	print("check run status function output")
	check_run_status_url= run_thread_url + "/" + run_id
	http_5 = HTTPRequest.new()
	self.add_child(http_5)
	http_5.connect("request_completed", self, "_on_run_status_checked")
	var error = http_5.request(check_run_status_url, headers, false, HTTPClient.METHOD_GET,"")
	print("error code ", error)
	
func _on_run_status_checked(result, response_code, headers, body) -> void:
	print("on run status checked function output")
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		var status = response["status"]
		print("Run status:", status)
		if status != "completed":
			status_check_timer.start()
		else:
			list_messages()
			status_check_timer.stop()
			
func _on_timer_timeout() -> void:
	check_run_status()
			
	
func list_messages():
	print("list messages function output")
	list_messages_url = create_message_url
	http_4 = HTTPRequest.new()
	self.add_child(http_4)
	http_4.connect("request_completed", self, "_list_messages_request_completed")
	var error = http_4.request(list_messages_url, headers, false, HTTPClient.METHOD_GET,"")
	print("error code ", error)


#YOU WILL HAVE TO CHANGE THIS IN ORDER TO ENABLE ONGOING CONVERSATIONS
func _list_messages_request_completed(result, response_code, headers, body) -> void:
	print("list messages request completed function output")
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		var bot_reply = response["data"][0]["content"][0]["text"]["value"]
		print(response)
		print(bot_reply)
		#bot_reply_label.text = bot_reply
		_panel.visible = true
		if status_check_timer.is_connected("timeout", self, "_on_timer_timeout"):
			status_check_timer.disconnect("timeout", self, "_on_timer_timeout")
		emit_signal("bot_reply_ready", bot_reply)
		_submit.disabled = false
		remove_child(status_check_timer)

	
	
	


	
#code for later...this will enable you to access all messages or all contents within a message by iterating over the arrays accordingly. 
#var bot_replies = []
#for message in response["data"]:
#    for content in message["content"]:
#        if "text" in content:
#            bot_replies.append(content["text"]["value"])

	
	
	



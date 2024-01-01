extends Node

var all_messages = []
var inbox = []
var read = []
var file_path = "res://assets/data/messages.json"
var game_manager = null

signal new_message(message: Message)

func _ready():
	game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.coins_updated.connect(on_coins_updated)
	
func is_unread(message: Message):
	for read_message in read:
		if message.id == read_message.id:
			return false
			
	return true
	
func on_coins_updated(coins: int):
	for message in all_messages:
		if message.coin_trigger <= coins:
			var already_received = false
			for inbox_message in inbox:
				if inbox_message.id == message.id:
					already_received = true
			
			if not already_received:
				add_new_message_to_inbox(message)
			
func add_new_message_to_inbox(message: Message):
	inbox.push_front(message)
	new_message.emit(message)
	
func mark_as_read(message: Message):
	read.append(message)

func load_messages_from_json():
	if not FileAccess.file_exists(file_path):
		print("No messages JSON found at %s" % file_path)
		return
	
	var messages = FileAccess.open(file_path, FileAccess.READ)
	
	if messages.get_length() == 0:
		print("No messages found in JSON file at %s" % file_path)
		return
		
	var json_string = messages.get_as_text()
	messages.close()

	var json = JSON.new()
	
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Message JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	var messages_data = json.get_data()
		
	for message_data in messages_data:
		var message = Message.new()
		message.load(message_data)
		message.id = UniqueIdGenerator.get_next_id()
		all_messages.append(message)
		
func save():
	var inbox_data = []
	var read_data = []
	
	for inbox_message in inbox:
		var inbox_string = inbox_message.save()
		inbox_data.append(inbox_message.save())
	
	for read_message in read:
		read_data.append(read_message.save())
		
	return {
		"inbox": inbox_data,
		"read": read_data
	}
	
func load(message_data):
	if !message_data.has("inbox") and !message_data.has("read"):
		print("Tried to load incorrect message data")
		return
	
	for inbox_data in message_data["inbox"]:
		var message = Message.new()
		message.id = UniqueIdGenerator.get_next_id()
		message.load(inbox_data)
		inbox.append(message)
	
	for read_data in message_data["read"]:
		var message = Message.new()
		message.id = UniqueIdGenerator.get_next_id()
		message.load(read_data)
		read.append(message)
	
func reset():
	all_messages = []
	inbox = []
	read = []
	
	load_messages_from_json()
	add_new_message_to_inbox(all_messages[0])

extends Node

var player_save_path = "user://player.save"
var shop_save_path = "user://shop.save"
var messages_save_path = "user://messages.save"
var events_save_path = "user://events.save"

func save_player():
	var save_game = FileAccess.open(player_save_path, FileAccess.WRITE)

	var game_data = Player.save()
	var game_data_string = JSON.stringify(game_data)
	save_game.store_line(game_data_string)
	
func save_shop():
	var save_game = FileAccess.open(shop_save_path, FileAccess.WRITE)
	var shop = get_tree().root.get_node("Main/ShopManager")
			
	if !shop.has_method("save"):
		print("Shop Manager has no `save` function")

	var game_data = shop.save()
	var game_data_string = JSON.stringify(game_data)
	save_game.store_line(game_data_string)
	
func save_messages():
	var save_game = FileAccess.open(messages_save_path, FileAccess.WRITE)
	var messages_data = MessageManager.save()
	var messages_data_string = JSON.stringify(messages_data)
	save_game.store_line(messages_data_string)
	
func save_events():
	var save_game = FileAccess.open(events_save_path, FileAccess.WRITE)
	var events_data = EventManager.save()
	var events_data_string = JSON.stringify(events_data)
	save_game.store_line(events_data_string)
	
func get_messages_data():
	if not FileAccess.file_exists(messages_save_path):
		print("no messages save data found")
		return null
	
	var save_game = FileAccess.open(messages_save_path, FileAccess.READ)
	
	if save_game.get_length() == 0:
		print("Messages save file empty")
		return
		
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		
		var save_parse = json.parse(json_string)
		if not save_parse == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
			
		var game_data = json.get_data()
			
		return game_data

func get_events_data():
	if not FileAccess.file_exists(events_save_path):
		print("no events save data found")
		return null
	
	var save_game = FileAccess.open(events_save_path, FileAccess.READ)
	
	if save_game.get_length() == 0:
		print("Events save file empty")
		return
		
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		
		var save_parse = json.parse(json_string)
		if not save_parse == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
			
		var game_data = json.get_data()
			
		return game_data

	
func get_player_data():
	if not FileAccess.file_exists(player_save_path):
		print('no load found')
		return null
		
	var save_game = FileAccess.open(player_save_path, FileAccess.READ)
	
	if save_game.get_length() == 0:
		print('save game empty')
		return

	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		
		var save_parse = json.parse(json_string)
		if not save_parse == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
			
		var game_data = json.get_data()
			
		return game_data
		
func get_shop_data():
	if not FileAccess.file_exists(shop_save_path):
		print('no load found')
		return null
		
	var save_game = FileAccess.open(shop_save_path, FileAccess.READ)
	
	if save_game.get_length() == 0:
		print('save game empty')
		return

	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		
		var save_parse = json.parse(json_string)
		if not save_parse == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
			
		var game_data = json.get_data()

		return game_data
		
func wipe_save():
	if FileAccess.file_exists(player_save_path):
		DirAccess.remove_absolute(player_save_path)
		
	if FileAccess.file_exists(shop_save_path):
		DirAccess.remove_absolute(shop_save_path)
	
	if FileAccess.file_exists(messages_save_path):
		DirAccess.remove_absolute(messages_save_path)

	if FileAccess.file_exists(events_save_path):
		DirAccess.remove_absolute(events_save_path)

extends Node

var player_save_path = "user://player.save"
var shop_save_path = "user://shop.save"

func save_player():
	var save_game = FileAccess.open(player_save_path, FileAccess.WRITE)
	var player = get_tree().root.get_node("Main/Player")
			
	if !player.has_method("save"):
		print("Game Manager has no `save` function")

	var game_data = player.save()
	var game_data_string = JSON.stringify(game_data)
	save_game.store_line(game_data_string)
	
func save_shop():
	var save_game = FileAccess.open(shop_save_path, FileAccess.WRITE)
	var player = get_tree().root.get_node("Main/ShopManager")
			
	if !player.has_method("save"):
		print("Shop Manager has no `save` function")

	var game_data = player.save()
	var game_data_string = JSON.stringify(game_data)
	save_game.store_line(game_data_string)
	
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
		
		if game_data["filename"] == "" or game_data["parent"] == "":
			return null
			
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

extends Node

var total_coins = 0
var current_coins = 0
var fractional_coins = 0.0
var per_second_rate = 0.0
var purchased_miners: Array[Miner]
var cursor_click_boost = 1
var new_game_plus_count = 0
var new_game_coins = 0

signal player_loaded(player: Player)

func save():
	var miner_data = []
	for miner in purchased_miners:
		miner_data.append(miner.save())

	return {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"total_coins": total_coins,
		"current_coins": current_coins,
		"fractional_coins": fractional_coins,
		"purchased_miners": miner_data,
		"per_second_rate": per_second_rate,
		"cursor_click_boost": cursor_click_boost,
		"new_game_plus_count": new_game_plus_count,
		"new_game_coins": new_game_coins
	}
	
func reset():
	total_coins = 0
	current_coins = 0
	fractional_coins = 0.0
	per_second_rate = 0.0
	purchased_miners = []
	new_game_coins = 0
	new_game_plus_count = 0
	
	player_loaded.emit(self)

func load(player_data):
	for miner_data in player_data["purchased_miners"]:
		var miner = Miner.new()
		miner.load(miner_data)
		purchased_miners.append(miner)

	for i in player_data.keys():
		set(i, player_data[i])

	call_deferred("emit_player_loaded")
	
func emit_player_loaded():
	player_loaded.emit(self)
	

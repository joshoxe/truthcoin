class_name ShopManager extends Node

var shop_miners = Array()
signal miner_updated(miner: Miner)

func load(game_data):
		for miner_data in game_data["shop_miners"]:
			var miner = Miner.new()
			miner.load(miner_data)
			shop_miners.append(miner)

func read_miners_from_json(file_path):
	if not FileAccess.file_exists(file_path):
		print("No miners JSON found at %s" % file_path)
		return
	
	var miners = FileAccess.open(file_path, FileAccess.READ)
	
	if miners.get_length() == 0:
		print("No miners found in JSON file at %s" % file_path)
		return
		
	var json_string = miners.get_as_text()
	miners.close()

	var json = JSON.new()
	
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Miner JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	var miners_data = json.get_data()
		
	for miner_data in miners_data:
		var miner = Miner.new()
		for key in miner_data.keys():
			miner.set(key, miner_data[key])

		miner.id = UniqueIdGenerator.get_next_id()
		shop_miners.append(miner)
		
func get_miner_by_id(miner_id: int):
	for miner in shop_miners:
		if miner.id == miner_id:
			return miner
			
func adjust_miner_base_cost(miner_id, cost):
	var miner = get_miner_by_id(miner_id)
	miner.base_cost = cost

func miner_purchased(miner_id):
	var miner = get_miner_by_id(miner_id)
	adjust_miner_base_cost(miner.id, miner.base_cost * miner.cost_multiplier)
	miner_updated.emit(get_miner_by_id(miner_id))

func save():
	var miner_data = []
	for miner in shop_miners:
		miner_data.append(miner.save())
		
	return {
		"shop_miners": miner_data
	}

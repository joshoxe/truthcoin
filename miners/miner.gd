class_name Miner

var id: int
var miner_name: String
var description: String
var base_cost: int
var earn_rate: float
var cost_multiplier: float
var image_path: String


func save():
	return {
		"id": id,
		"miner_name": miner_name,
		"description": description,
		"base_cost": base_cost,
		"earn_rate": earn_rate,
		"cost_multiplier": cost_multiplier,
		"image_path": image_path
	}

func load(miner_data):
	for i in miner_data.keys():
		set(i, miner_data[i])

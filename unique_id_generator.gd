extends Node
var unique_id_counter = 0

func get_next_id():
	unique_id_counter += 1
	return unique_id_counter

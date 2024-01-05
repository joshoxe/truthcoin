class_name GameEffect extends Node

var key: String
var value: float

func load(data):
	key = data.key
	value = data.value

func save():
	return {
		"key": key,
		"value": value
	}

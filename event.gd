class_name Event extends Node

var event_name: String
var description: String
var end_text: String
var buff_text: String
var buff_effect: String
var effects: Array[GameEffect]
var duration: int
var probability: float

func load(data):
	event_name = data["event_name"]
	description = data["description"]
	end_text = data["end_text"]
	buff_text = data["buff_text"]
	buff_effect = data["buff_effect"]
	duration = data["duration"]
	probability = data["probability"]
	effects = []
	for effect_data in data["effects"]:
		var effect = GameEffect.new()
		effect.load(effect_data)
		effects.append(effect)

func save():
	var effect_data = []
	for effect in effects:
		effect_data.append(effect.save())
	return {
		"event_name": event_name,
		"description": description,
		"end_text": end_text,
		"buff_text": buff_text,
		"buff_effect": buff_effect,
		"duration": duration,
		"probability": probability,
		"effects": effect_data
	}

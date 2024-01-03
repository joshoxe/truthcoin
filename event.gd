class_name Event extends Node

var effect_name: String
var description: String
var effects: Array[GameEffect]
var duration: int
var probability: float

func load(data):
		name = data["name"]
		description = data["description"]
		duration = data["duration"]
		probability = data["probability"]
		effects = []
		for effect_data in data["effects"]:
			var effect = GameEffect.new()
			effects.append(effect.load(effect_data))

func save():
	var effect_data = []
	for effect in effects:
		effect_data.append(effect.save())
	return {
		"name": effect_name,
		"description": description,
		"duration": duration,
		"probability": probability,
		"effects": effect_data
	}

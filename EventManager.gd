extends Node

var events = []
var active_events = []

func _ready():
	# Load events from JSON
	events = load_events_from_json("res://events.json")

func _process(delta):
	if (randf() < get_event_trigger_probability()):
		trigger_random_event()

func trigger_random_event():
	var event = select_random_event()
	apply_event(event)
	# Set a timer to end the event
	var timer = Timer.new()
	timer.wait_time = event.duration
	timer.one_shot = true
	timer.timeout.connect(_on_event_timeout)
	add_child(timer)
	timer.start()
	active_events.append(event)

func load_events_from_json(path):
	var events = []
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	var events_data = json.parse(file.get_as_text())
	file.close()
	for event_data in events_data:
		var event = Event.new()
		event.load(event_data)
		events.append(event)
	return events

func _on_event_timeout(event):
	revert_event(event)
	active_events.erase(event)

func apply_event(event):
	match event.effect.key:
		"cps_boost":
			apply_cps_boost(event.effect.value)

func apply_cps_boost(value):
	var game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.apply_cps_boost(value)
	

func revert_event(event):
	match event.effect.key:
		"cps_boost":
			revert_cps_boost(event.effect.value)

func revert_cps_boost(value):
	var game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.revert_cps_boost(value)

func get_event_trigger_probability():
	var probability = 0
	for event in events:
		probability += event.probability
	return probability

func select_random_event():
	var probability = randf() * get_event_trigger_probability()
	for event in events:
		probability -= event.probability
		if (probability <= 0):
			return event

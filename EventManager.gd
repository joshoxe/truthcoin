extends Node

var events = []
var active_events = []
signal new_event(event: Event)
signal event_ended(event: Event)
var event_check_interval = 10.0  # Time in seconds between each event check
var event_timer = Timer.new()

func _ready():
	# Load events from JSON
	load_events_from_json("res://events.json")
	event_timer.wait_time = event_check_interval
	event_timer.one_shot = false  # Repeat the timer
	event_timer.timeout.connect(_on_event_timer_timeout)
	add_child(event_timer)
	event_timer.start()

func _on_event_timer_timeout():
	var random_chance = randf()
	var event_probability = get_event_trigger_probability()
	if (random_chance < event_probability):
		trigger_random_event()

func trigger_random_event():
	var event = select_random_event()
	if event in active_events:
		return
	apply_event(event)
	# Set a timer to end the event
	var timer = Timer.new()
	timer.wait_time = event.duration
	timer.one_shot = true
	timer.timeout.connect(_on_event_timeout.bind(event))
	add_child(timer)
	timer.start()
	active_events.append(event)
	new_event.emit(event)

func load_events_from_json(path):
	if not FileAccess.file_exists(path):
		print("No events JSON found at %s" % path)
		return

	var events_file = FileAccess.open(path, FileAccess.READ)

	if events_file.get_length() == 0:
		print("No events found in JSON")
		return

	var json_string = events_file.get_as_text()
	events_file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("Events JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	var events_data = json.get_data()
	
	for event_data in events_data:
		var event = Event.new()
		event.load(event_data)
		events.append(event)

func _on_event_timeout(event):
	revert_event(event)
	active_events.erase(event)
	event_ended.emit(event)

func apply_event(event):
	for effect in event.effects:
		match effect.key:
			"cps_boost":
				apply_cps_boost(effect.value)

func apply_cps_boost(value):
	var game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.apply_cps_boost(value)
	

func revert_event(event):
	for effect in event.effects:
		match effect.key:
			"cps_boost":
				revert_cps_boost(effect.value)

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

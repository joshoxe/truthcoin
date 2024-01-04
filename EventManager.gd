extends Node

var events = []
var active_events = []
signal show_event_coin
signal new_event(event: Event)
signal event_ended(event: Event)
signal load_event(event: Event)
var event_check_interval = randf_range(10.0, 60.0)
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
		show_event_coin.emit()
	event_timer.wait_time = randf_range(10.0, 60.0)

func trigger_random_event():
	var event = select_random_event()

	for active_event in active_events:
		if active_event.event_name == event.event_name:
			trigger_random_event()
			return

	print('starting event ', event.event_name)
	apply_event(event)
	# Set a timer to end the event
	var timer = Timer.new()
	timer.wait_time = event.duration
	timer.one_shot = true
	timer.timeout.connect(_on_event_timeout.bind(event))
	add_child(timer)
	timer.start()
	active_events.append(event)
	print('appended')
	print(active_events)
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
	var game_manager = get_tree().root.get_node("Main/GameManager")
	for effect in event.effects:
		match effect.key:
			"cps_boost":
				apply_cps_boost(effect.value)
			"miner_price":
				apply_miner_price(effect.value)
			"quantum_anomaly":
				game_manager.apply_quantum_anomaly()
			"cursor_clicks":
				game_manager.apply_cursor_click_boost(effect.value)
			"grandpa_cps":
				game_manager.apply_grandpa_cps(effect.value)

func apply_cps_boost(value):
	var game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.apply_cps_boost(value)

func apply_miner_price(value):
	var game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.apply_miner_price(value)
	

func revert_event(event):
	var game_manager = get_tree().root.get_node("Main/GameManager")
	for effect in event.effects:
		match effect.key:
			"cps_boost":
				revert_cps_boost(effect.value)
			"miner_price":
				revert_miner_price(effect.value)
			"quantum_anomaly":
				game_manager.revert_quantum_anomaly()
			"cursor_clicks":
				game_manager.revert_cursor_click_boost(effect.value)
			"grandpa_cps":
				game_manager.revert_grandpa_cps(effect.value)
				

func revert_cps_boost(value):
	var game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.revert_cps_boost(value)

func revert_miner_price(value):
	var game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.revert_miner_price(value)

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


func save():
	var active_events_data = []
	print('looping active events')
	for event in active_events:
		print(event.event_name)
		var event_string = event.save()
		print(event_string)
		active_events_data.append(event_string)

	return {
		"active_events": active_events_data
	}

func load(active_events_data):
	for event_data in active_events_data['active_events']:
		var event = Event.new()
		event.load(event_data)
		var timer = Timer.new()
		timer.wait_time = event.duration
		timer.one_shot = true
		timer.timeout.connect(_on_event_timeout.bind(event))
		add_child(timer)
		timer.start()
		active_events.append(event)
		print('emitting for')
		print(event.event_name)
		call_deferred('emit_event_loaded', event)
		
func emit_event_loaded(event):
	load_event.emit(event)

func reset():
	for event in active_events:
		revert_event(event)
		event_ended.emit(event)
	active_events.clear()

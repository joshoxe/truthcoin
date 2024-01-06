extends Node

var all_news = []
var news_timer: Timer

signal news_ready(news: String)

func _ready():
	load_messages_from_json("res://news.json")
	news_timer = Timer.new()
	news_timer.set_wait_time(1)
	news_timer.set_one_shot(true)
	news_timer.timeout.connect(on_news_timer_timeout)
	add_child(news_timer)
	news_timer.start()
	
func trigger_news():
	var news = get_random_news_for_total_coins()
	if news != null:
		call_deferred("emit_news", news)

func emit_news(news):
	news_ready.emit(news.message)

func on_news_timer_timeout():
	trigger_news()
	news_timer.set_wait_time(randi_range(10, 30))
	news_timer.start()

func get_random_news_for_total_coins():
	var coins = Player.total_coins

	var valid_news = []
	for news in all_news:
		if coins >= news.coins_start and coins <= news.coins_end:
			valid_news.append(news)

	if valid_news.size() == 0:	
		return null

	var random_index = randi_range(0, valid_news.size() - 1)
	return valid_news[random_index]

func load_messages_from_json(path):
	if not FileAccess.file_exists(path):
		print("No messages JSON found at %s" % path)
		return

	var news_file = FileAccess.open(path, FileAccess.READ)

	if news_file.get_length() == 0:
		print("No messages found in JSON")
		return

	var json_string = news_file.get_as_text()
	news_file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("Events JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	var news_data = json.get_data()
	
	for message_data in news_data:
		var news = News.new()
		news.load(message_data)
		all_news.append(news)

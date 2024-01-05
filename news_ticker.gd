extends TextureRect

var current_news = ""

func _ready():
	NewsManager.news_ready.connect(on_news_ready)
	
func on_news_ready(news):
	add_new_news_ticket(news)

func add_new_news_ticket(news):
	current_news = news
	var tween = get_tree().create_tween()
	tween.tween_property($NewsLabel, "modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_callback(on_tween_completed)

func on_tween_completed():
	$NewsLabel.text = current_news
	var tween_up = get_tree().create_tween()
	tween_up.tween_property($NewsLabel, "modulate", Color(1, 1, 1, 1), 1.0)

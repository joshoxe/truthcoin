extends CanvasLayer

var game_manager = null
var current_score = 0
var target_score = 0
var positive_score_step = 0.03
var negative_score_step = 0.00001

func _ready():
	game_manager = get_node("/root/Main/GameManager")
	game_manager.coins_updated.connect(on_coins_updated)
	game_manager.per_second_rate_updated.connect(on_per_second_rate_updated)
	$ScoreUpdateTimer.timeout.connect(on_score_update_timer_timeout)
	
func on_per_second_rate_updated(rate: float):
	$ColorRect/PerSecondLabel.text = "%10.2f per second" % rate

func update_coins(coins):
	target_score = coins
	$ScoreUpdateTimer.start()

func on_score_update_timer_timeout():
	if current_score < target_score:
		$ScoreUpdateTimer.wait_time = positive_score_step
		current_score += 1
	elif current_score > target_score:
		$ScoreUpdateTimer.wait_time = negative_score_step
		current_score -= 1
	else:
		$ScoreUpdateTimer.stop()
	
	$ScoreLabel.text = "[center][font_size=48]" + str(current_score) + "[/font_size] truthcoins"

	if current_score != target_score:
		$ScoreUpdateTimer.start()

func update_label():
	$ScoreLabel.text = "[center][font_size=48]" + str(int(current_score)) + "[/font_size] truthcoins"
	if current_score != target_score:
		call_deferred("update_label")

func on_coins_updated(coins):
	print("new coins" + str(coins))
	coins = round(coins)
	update_coins(coins)

extends CanvasLayer

var game_manager = null
var current_score = 0
var target_score = 0
var positive_score_timer = 0.03
var negative_score_timer = 0.00001
var positive_score_step = 1
var negative_score_step = 8
var player = null

func _ready():
	game_manager = get_node("/root/Main/GameManager")
	game_manager.coins_updated.connect(on_coins_updated)
	game_manager.per_second_rate_updated.connect(on_per_second_rate_updated)
	$ScoreUpdateTimer.timeout.connect(on_score_update_timer_timeout)
	player = get_tree().root.get_node("Main/Player")
	player.player_loaded.connect(on_player_loaded)

func on_player_loaded(player: Player):
	current_score = player.current_coins
	$ScoreLabel.text = "[center][font_size=48]" + str(current_score) + "[/font_size] truthcoins"
	
	if player.per_second_rate != null and player.per_second_rate > 0:
		$ColorRect/PerSecondLabel.text = "%10.2f per second" % player.per_second_rate
	if player.per_second_rate == 0:
		$ColorRect/PerSecondLabel.text = ""
	
func on_per_second_rate_updated(rate: float):
	$ColorRect/PerSecondLabel.text = "%10.2f per second" % rate

func update_coins(coins):
	target_score = coins
	$ScoreUpdateTimer.start()

func on_score_update_timer_timeout():
	if current_score < target_score:
		$ScoreUpdateTimer.wait_time = positive_score_timer
		current_score += positive_score_step
	elif current_score > target_score:
		$ScoreUpdateTimer.wait_time = negative_score_timer
		current_score -= 8
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
	coins = round(coins)
	update_coins(coins)

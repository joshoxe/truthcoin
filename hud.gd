extends CanvasLayer

var game_manager = null
var current_score = 0
var target_score = 0
var positive_score_timer = 0.03
var negative_score_timer = 0.00001
var positive_score_step = 1
var negative_score_step = 8
var player = null
var displayed_score = 0
var actual_score = 0

func _ready():
	game_manager = get_node("/root/Main/GameManager")
	game_manager.coins_updated.connect(on_coins_updated)
	game_manager.per_second_rate_updated.connect(on_per_second_rate_updated)
	game_manager.new_game_coins_updated.connect(on_new_game_coins_updated)
	player = get_tree().root.get_node("Main/Player")
	Player.player_loaded.connect(on_player_loaded)
	
func on_new_game_coins_updated():
	update_cipher_coins_label()

func on_player_loaded(player: Player):
	$ScoreLabel.text = "[center][font_size=48]" + str(current_score) + "[/font_size] truthcoins"
	
	if Player.per_second_rate != null and Player.per_second_rate > 0:
		$ColorRect/PerSecondLabel.text = "%10.2f per second" % Player.per_second_rate
	if Player.per_second_rate == 0:
		$ColorRect/PerSecondLabel.text = ""
		
	update_cipher_coins_label()
	
func on_per_second_rate_updated(rate: float):
	$ColorRect/PerSecondLabel.text = "%10.2f per second" % rate

func _process(delta):
	actual_score = Player.current_coins
	
	var rate_of_increase = Player.per_second_rate * delta
	var difference = actual_score - displayed_score
	
	var update_step = max(abs(difference), max(rate_of_increase, 1))
	
	if difference != 0:
		displayed_score += sign(difference) * int(update_step)
		
	$ScoreLabel.text = "[center][font_size=48]" + pretty_print_number(displayed_score) + "[/font_size] truthcoins"

func pretty_print_number(num):
	return format_number_with_commas(num)
	
func format_number_with_commas(num):
	var num_str = str(int(num))
	var formatted_str = ""
	var counter = 0

	for i in range(num_str.length() - 1, -1, -1):
		counter += 1
		formatted_str = num_str[i] + formatted_str
		if counter % 3 == 0 and i != 0:
			formatted_str = "," + formatted_str

	return formatted_str
	
func update_label():
	$ScoreLabel.text = "[center][font_size=48]" + pretty_print_number(current_score) + "[/font_size] truthcoins"
	if current_score != target_score:
		call_deferred("update_label")

func on_coins_updated(coins):
	displayed_score = int(coins)
	
func update_cipher_coins_label():
	$ColorRect/NewGameCoinsLabel.text = "%s cipher coins" % pretty_print_number(Player.new_game_coins)

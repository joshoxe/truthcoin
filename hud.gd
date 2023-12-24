extends CanvasLayer

var game_manager = null

func _ready():
	game_manager = get_node("/root/Main/GameManager")
	game_manager.coins_updated.connect(on_coins_updated)

func update_coins(coins):
	$ScoreLabel.text = "[center][font_size=48]" + str(coins) + "[/font_size] truthcoins"

func on_coins_updated(coins):
	coins = round(coins)
	update_coins(coins)

extends CanvasLayer

var game_manager = null

func _ready():
	var game_manager = get_node("/root/Main/GameManager")
	game_manager.coins_updated.connect(on_coins_updated)
	
# Called when the node enters the scene tree for the first time.
func update_coins(coins):
	$ScoreLabel.text = str(coins)

func on_coins_updated(coins):
	coins = round(coins)
	update_coins(coins)

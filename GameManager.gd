extends Node

var total_coins = 0.0
signal coins_updated(coins: float)

func _ready():
	var clickable_coin = get_tree().root.get_node("Main/Container/ClickableCoin")
	clickable_coin.clicked.connect(on_clickable_coin_clicked)

	
func on_clickable_coin_clicked():
	increase_coins(1)
	coins_updated.emit(total_coins)
	
func increase_coins(amount: float):
	total_coins += amount

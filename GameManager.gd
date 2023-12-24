extends Node

var total_coins = 0.0
@export var falling_coin_scene: PackedScene
signal coins_updated(coins: float)


func _ready():
	var clickable_coin = get_tree().root.get_node("Main/Container/ClickableCoin")
	clickable_coin.clicked.connect(on_clickable_coin_clicked)

	
func on_clickable_coin_clicked():
	increase_coins(1)
	coins_updated.emit(total_coins)
	
func increase_coins(amount: float):
	total_coins += amount
	spawn_falling_coin()

func spawn_falling_coin():
	var falling_coin = falling_coin_scene.instantiate()
	var path = get_tree().root.get_node("Main/FallingCoinPath/FallingCoinSpawn")
	path.progress_ratio = randf()
	print(path.position)
	falling_coin.position = path.position
	get_tree().root.get_node("Main").add_child(falling_coin)

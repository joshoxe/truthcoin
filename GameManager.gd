extends Node

var total_coins = 0
var current_coins = 0
var fractional_coins = 0.0
var per_second_rate = 0.0
@export var falling_coin_scene: PackedScene
signal coins_updated(coins: int)
signal miner_purchase_success(miner: Miner)
signal per_second_rate_updated(rate: float)
var purchased_miners: Array[Miner]
var rng = RandomNumberGenerator.new()

func _ready():
	var clickable_coin = get_tree().root.get_node("Main/Container/ClickableCoin")
	clickable_coin.clicked.connect(on_clickable_coin_clicked)
	var miner = Miner.new()
	$CoinTimer.timeout.connect(on_coin_timer_timeout)
	calculate_per_second_rate()

	$CoinTimer.start()
	
func calculate_per_second_rate():
	per_second_rate = 0

	for purchased_miner in purchased_miners:
		per_second_rate += purchased_miner.earn_rate
	
	per_second_rate_updated.emit(per_second_rate)

func on_coin_timer_timeout():
	print("Timed out after " + str($CoinTimer.wait_time))
	increase_coins_from_miners(per_second_rate)
	
	if (per_second_rate > 0):
		$CoinTimer.wait_time = 1 / per_second_rate
	
func on_clickable_coin_clicked():
	increase_coins(1)

func increase_coins_from_miners(amount: float):
	fractional_coins += per_second_rate * $CoinTimer.wait_time
	var whole_coins = int(fractional_coins)
	fractional_coins -= whole_coins
	increase_coins(whole_coins)
		
func increase_coins(whole_coins):
	current_coins += whole_coins
	total_coins += whole_coins

	coins_updated.emit(current_coins)
	spawn_falling_coin()
	
func remove_coins(amount: int):
	current_coins -= amount
	coins_updated.emit(current_coins)

func add_purchased_miner(miner: Miner):
	if current_coins < miner.base_cost:
		return

	remove_coins(miner.base_cost)
	purchased_miners.append(miner)
	miner_purchase_success.emit(miner)
	calculate_per_second_rate()

func find_owned_miners_of_name(miner_name: String):
	var owned = 0
	
	for miner in purchased_miners:
		if miner.miner_name == miner_name:
			owned += 1
			
	return owned

func spawn_falling_coin():
	var falling_coin = falling_coin_scene.instantiate()
	var path = get_tree().root.get_node("Main/FallingCoinPath/FallingCoinSpawn")
	path.progress_ratio = randf()
	falling_coin.position = path.position
	falling_coin.position.y += rng.randi_range(-200, -500)
	get_tree().root.get_node("Main").add_child(falling_coin)

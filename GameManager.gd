extends Node

@export var falling_coin_scene: PackedScene
var shop_manager: Node
signal coins_updated(coins: int)
signal miner_purchase_success(miner: Miner)
signal per_second_rate_updated(rate: float)
signal new_game_coins_updated()
var rng = RandomNumberGenerator.new()

var cps_boosts = [1.0]

func _ready():
	MessageManager.load_messages_from_json()
	MessageManager.new_message.connect(on_new_message)
	EventManager.new_event.connect(on_new_event)
	EventManager.event_ended.connect(on_event_ended)
		
	var player_data = await get_tree().root.get_node("Main/SaveGame").get_player_data()
	var shop_data = await get_tree().root.get_node("Main/SaveGame").get_shop_data()
	var messages_data = await get_tree().root.get_node("Main/SaveGame").get_messages_data()
	var events_data = await get_tree().root.get_node("Main/SaveGame").get_events_data()
	shop_manager = get_tree().root.get_node("Main/ShopManager")
	var main_hud = get_tree().root.get_node("Main/MainHUD")
	if player_data != null:
		Player.load(player_data)
		
	if shop_data != null:
		shop_manager.load(shop_data)
	else:
		shop_manager.read_miners_from_json("res://assets/data/miners.json")

	if messages_data != null:
		MessageManager.load(messages_data)

	if events_data != null:
		EventManager.load(events_data)

	var clickable_coin = get_tree().root.get_node("Main/Container/ClickableCoin")
	clickable_coin.clicked.connect(on_clickable_coin_clicked)
	$CoinTimer.timeout.connect(on_coin_timer_timeout)
	calculate_per_second_rate()
	
	main_hud.wipe_save.connect(on_wipe_save)
	shop_manager.miner_updated.connect(on_miner_updated)

	$CoinTimer.start()

func on_clickable_coin_clicked():
	increase_coins(1 * Player.cursor_click_boost)

func on_wipe_save():
	var save_game = get_tree().root.get_node("Main/SaveGame")
	var shop_manager = get_tree().root.get_node("Main/ShopManager")
	UniqueIdGenerator.reset()
	MessageManager.reset()
	EventManager.reset()
	await save_game.wipe_save()
	await shop_manager.reset()
	await Player.reset()
	increase_coins(0)

func on_new_event(event: Event):
	save_events()

func on_event_ended(event: Event):
	save_events()

func on_miner_updated(_miner: Miner):
	save_shop()
	
func calculate_per_second_rate():
	Player.per_second_rate = 0

	for purchased_miner in Player.purchased_miners:
		Player.per_second_rate += purchased_miner.earn_rate
		
	for cps_boost in cps_boosts:
		Player.per_second_rate *= cps_boost

	Player.per_second_rate += Player.per_second_rate * (0.02 * Player.new_game_coins)
	
	per_second_rate_updated.emit(Player.per_second_rate)

func on_coin_timer_timeout():
	# Calculate coin increase based on the elapsed time and per_second_rate
	var elapsed_time = $CoinTimer.wait_time
	increase_coins_from_miners(Player.per_second_rate * elapsed_time)

func increase_coins_from_miners(amount: float):
	var whole_coins = int(amount)
	Player.fractional_coins += (amount - whole_coins)
	if Player.fractional_coins >= 1.0:
		whole_coins += int(Player.fractional_coins)
		Player.fractional_coins -= int(Player.fractional_coins)
	increase_coins(whole_coins)

func increase_coins(whole_coins):
	if whole_coins > 0:
		Player.current_coins += whole_coins
		Player.total_coins += whole_coins

		coins_updated.emit(Player.current_coins)
		spawn_falling_coin()
		save_player()

func remove_coins(amount: int):
	Player.current_coins -= amount
	coins_updated.emit(Player.current_coins)

func add_purchased_miner(miner: Miner):
	if Player.current_coins < miner.base_cost:
		return
		
	if miner.miner_name == "Cipher":
		handle_end_game(miner)
		return

	remove_coins(miner.base_cost)
	Player.purchased_miners.append(miner)
	shop_manager.miner_purchased(miner.id)
	miner_purchase_success.emit(miner)
	calculate_per_second_rate()
	save_player()
	
func handle_end_game(miner):
	var current_coins = Player.current_coins

	on_wipe_save()
	Player.new_game_coins += (current_coins - miner.base_cost)

	if Player.new_game_coins >= 12:
		Player.new_game_coins = 12

	new_game_coins_updated.emit()
	save_player()

func find_owned_miners_of_name(miner_name: String):
	var owned = 0
	
	for miner in Player.purchased_miners:
		if miner.miner_name == miner_name:
			owned += 1
			
	return owned

func spawn_falling_coin():
	var falling_coin = falling_coin_scene.instantiate()
	var path = get_tree().root.get_node("Main/FallingCoinPath/FallingCoinSpawn")
	path.progress_ratio = randf()
	falling_coin.position = path.position
	get_tree().root.get_node("Main").add_child(falling_coin)

func apply_cps_boost(boost: float):
	cps_boosts.append(boost)
	calculate_per_second_rate()

func apply_miner_price(price: float):
	for miner in shop_manager.shop_miners:
		miner.base_cost *= price
		shop_manager.miner_updated.emit(miner)
		
	save_shop()

func apply_grandpa_cps(boost):
	for miner in shop_manager.shop_miners:
		if miner.miner_name == "Gramps Crypto Rig":
			miner.earn_rate = boost
			shop_manager.miner_updated.emit(miner)

func apply_miner_earn_rate(rate: float):
	for miner in shop_manager.shop_miners:
		miner.earn_rate *= rate
		shop_manager.miner_updated.emit(miner)

func apply_quantum_anomaly():
	for miner in shop_manager.shop_miners:
		var random_factor = randf_range(0.5, 2.0)
		miner.earn_rate *= random_factor
		shop_manager.miner_updated.emit(miner)

func apply_cursor_click_boost(boost: int):
	Player.cursor_click_boost = boost

func revert_grandpa_cps(boost):
	for miner in shop_manager.shop_miners:
		if miner.miner_name == "Gramps Crypto Rig":
			miner.earn_rate = miner.original_earn_rate
			shop_manager.miner_updated.emit(miner)

func revert_cursor_click_boost(boost: int):
	Player.cursor_click_boost = 1

func revert_quantum_anomaly():
	for miner in shop_manager.shop_miners:
		miner.earn_rate = miner.original_earn_rate
		shop_manager.miner_updated.emit(miner)

func revert_miner_earn_rate(rate: float):
	for miner in shop_manager.shop_miners:
		miner.earn_rate /= rate
		shop_manager.miner_updated.emit(miner)

func revert_cps_boost(boost: float):
	cps_boosts.erase(boost)
	calculate_per_second_rate()

func revert_miner_price(price: float):
	for miner in shop_manager.shop_miners:
		miner.base_cost /= price
		shop_manager.miner_updated.emit(miner)
		
	save_shop()
	
func on_new_message(message: Message):
	save_messages()

func save_player():
	get_tree().root.get_node("Main/SaveGame").save_player()
	
func save_shop():
	get_tree().root.get_node("Main/SaveGame").save_shop()
	
func save_messages():
	get_tree().root.get_node("Main/SaveGame").save_messages()

func save_events():
	get_tree().root.get_node("Main/SaveGame").save_events()

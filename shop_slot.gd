extends TextureRect

var miner_id: int
var shop_manager = null
var player = null
var slot_visible = false
var amount_owned = 0
signal miner_purchased(miner)

func get_miner():
	return shop_manager.get_miner_by_id(miner_id)

func _ready():
	$BuyButton.pressed.connect(on_buy_button_pressed)
	shop_manager = get_tree().root.get_node("Main/ShopManager")
	shop_manager.miner_reset.connect(on_miner_reset)
	shop_manager.miner_updated.connect(on_miner_updated)
	player = get_tree().root.get_node("Main/Player")
	Player.player_loaded.connect(on_player_loaded)
	get_miners_owned()

func get_miners_owned():
	amount_owned = shop_manager.get_miners_owned(miner_id)
	$OwnedLabel.text = "Owned: %d" % amount_owned

func on_miner_updated(miner: Miner):
	get_miners_owned()

func on_miner_reset(miner: Miner):
	hide_miner()
	
func on_player_loaded(player: Player):
	var miner = get_miner()
	if Player.total_coins > miner.base_cost:
		show_miner()
		
	if Player.current_coins > miner.base_cost:
		enable_slot()
	
func check_player_can_afford(coins: int):
	var miner = get_miner()
	if coins < miner.base_cost:
		disable_slot()
	elif $DisabledOverlay.visible == true:
		show_miner()
		enable_slot()

func disable_slot():
	$DisabledOverlay.visible = true
	$BuyButton.disabled = true
	
func enable_slot():
	$DisabledOverlay.visible = false
	$BuyButton.disabled = false

func set_miner_id(new_miner_id: int):
	miner_id = new_miner_id
	
func show_miner():
	slot_visible = true
	var miner = get_miner()
	set_miner_image(miner.image_path)
	set_name_label(miner.miner_name)
	set_description_label(miner.description)
	set_cost_label(miner.base_cost)
	set_per_second_label(miner.earn_rate)
	
func hide_miner():
	remove_miner_image()
	set_name_label("???")
	set_description_label("??????")
	hide_cost_label()
	hide_per_second_label()

func on_buy_button_pressed():
	$BuyButton.disabled = true
	miner_purchased.emit(miner_id)

func set_miner_image(path: String):
	$MinerImage.texture = load(path)
	
func remove_miner_image():
	$MinerImage.texture = null
	
func set_name_label(name: String):
	$MinerName.text = name

func set_description_label(description: String):
	$MinerDescription.text = description
	
func set_cost_label(price: int):
	$CostLabel.text = "%d" % price

func hide_cost_label():
	$CostLabel.text = "??"

func set_per_second_label(ps: float):
	$PerSecondLabel.text = "%10.2f per second" % ps
	
func hide_per_second_label():
	$PerSecondLabel.text = "??"

func enable_buy_button():
	$BuyButton.disabled = false

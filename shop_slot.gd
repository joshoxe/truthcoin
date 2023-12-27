extends TextureRect

var slot_miner: Miner
var game_manager = null
signal miner_purchased(miner)

func _ready():
	$BuyButton.pressed.connect(on_buy_button_pressed)
	var game_manager = get_tree().root.get_node("Main/GameManager")
	game_manager.miner_purchase_success.connect(on_miner_purchase_success)
	game_manager.coins_updated.connect(on_coins_updated)
	
func on_coins_updated(coins: int):
	if coins < slot_miner.base_cost:
		disable_slot()
	else:
		show_miner()
		enable_slot()
	
func on_miner_purchase_success(miner: Miner):
	if miner.miner_name == slot_miner.miner_name:
		slot_miner.base_cost = slot_miner.base_cost * miner.cost_multiplier
		set_cost_label(slot_miner.base_cost)

func disable_slot():
	$DisabledOverlay.visible = true
	$BuyButton.disabled = true
	
func enable_slot():
	$DisabledOverlay.visible = false
	$BuyButton.disabled = false

func set_miner(miner: Miner):
	slot_miner = miner
	
func show_miner():
	set_miner_image(slot_miner.image_path)
	set_name_label(slot_miner.miner_name)
	set_description_label(slot_miner.description)
	set_cost_label(slot_miner.base_cost)
	set_per_second_label(slot_miner.earn_rate)

func on_buy_button_pressed():
	miner_purchased.emit(slot_miner)

func set_miner_image(path: String):
	$MinerImage.texture = load(path)
	
func set_name_label(name: String):
	$MinerName.text = name

func set_description_label(description: String):
	$MinerDescription.text = description
	
func set_cost_label(price: int):
	$CostLabel.text = "%d" % price

func set_per_second_label(ps: float):
	$PerSecondLabel.text = "%10.2f per second" % ps

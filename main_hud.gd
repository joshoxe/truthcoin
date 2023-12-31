extends CanvasLayer

var shop_manager = null
var game_manager = null
var player = null
@export var shop_slot_scene: PackedScene
var slots = []

var SHOP_SLOT_X = 1140
var SHOP_SLOT_Y = 150
var SHOP_SLOT_Y_ADDITION = 250

signal wipe_save

# Called when the node enters the scene tree for the first time.
func _ready():
	$"ButtonContainer/InboxButton".pressed.connect(on_inbox_button_clicked)
	$"ButtonContainer/ShopButton".pressed.connect(on_shop_button_clicked)
	$WipeSaveButton.pressed.connect(on_wipe_save_button_pressed)
	$WipeSaveDialogue/WipeSaveCancel.pressed.connect(on_wipe_save_cancel_pressed)
	$WipeSaveDialogue/WipeSaveConfirm.pressed.connect(on_wipe_save_confirm_pressed)
	shop_manager = get_tree().root.get_node("Main/ShopManager")
	game_manager = get_tree().root.get_node("Main/GameManager")
	shop_manager.miner_updated.connect(on_miner_updated)
	game_manager.coins_updated.connect(on_coins_updated)

	for miner in shop_manager.shop_miners:
		var shop_slot = shop_slot_scene.instantiate()
		shop_slot.position = Vector2(SHOP_SLOT_X, SHOP_SLOT_Y)
		shop_slot.set_miner_id(miner.id)
		shop_slot.miner_purchased.connect(on_miner_purchased)
		slots.append(shop_slot)
		$ShopScrollContainer/ShopContainer.add_child(shop_slot)
		
func on_coins_updated(coins: int):
	for slot in slots:
		slot.check_player_can_afford(coins)

func on_miner_purchased(miner_id: int):
	var miner = shop_manager.get_miner_by_id(miner_id)
	game_manager.add_purchased_miner(miner)
	
func on_miner_updated(miner):
	for slot in slots:
		if slot.miner_id == miner.id:
			slot.set_cost_label(miner.base_cost)
			slot.enable_buy_button()
			return
	
func on_inbox_button_clicked():
	$ShopScrollContainer.visible = false
	$InboxScrollContainer.visible = true
	
func on_shop_button_clicked():
	$InboxScrollContainer.visible = false
	$ShopScrollContainer.visible = true
	
func on_wipe_save_button_pressed():
	$WipeSaveDialogue.visible = true

func on_wipe_save_cancel_pressed():
	$WipeSaveDialogue.visible = false
	
func on_wipe_save_confirm_pressed():
	wipe_save.emit()
	$WipeSaveDialogue.visible = false
	


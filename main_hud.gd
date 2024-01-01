extends CanvasLayer

var shop_manager = null
var game_manager = null
var player = null
@export var shop_slot_scene: PackedScene
@export var message_slot_scene: PackedScene
var slots = []
var message_slots = []

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
	MessageManager.new_message.connect(on_new_message)
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
		
	for message in MessageManager.inbox:
		create_new_message_scene(message)
		
func reset_messages():
	var container = $InboxScrollContainer/InboxContainer
	while container.get_child_count() > 0:
		var child = container.get_child(0)
		container.remove_child(child)
		child.queue_free()

	message_slots.clear()

		
func on_message_clicked(message: Message):
	$MessageDialogue.message = message
	$MessageDialogue.display_message()
	$MessageDialogue.visible = true
	
	MessageManager.mark_as_read(message)
	
	for message_slot in message_slots:
		if message_slot.message.subject == message.subject:
			message_slot.display_message_as_read()
	
	get_tree().root.get_node("Main/SaveGame").save_messages()

func on_new_message(message: Message):
	create_new_message_scene(message, true)
		
func create_new_message_scene(message, new_message = false):
	var message_scene = message_slot_scene.instantiate()
	message_scene.position = Vector2(SHOP_SLOT_X, SHOP_SLOT_Y)
	message_scene.message = message
	
	if MessageManager.is_unread(message):
		message_scene.display_message_as_unread()
	else:
		message_scene.display_message_as_read()
		
	message_scene.clicked.connect(on_message_clicked)
	$InboxScrollContainer/InboxContainer.add_child(message_scene)
	if new_message:
		$InboxScrollContainer/InboxContainer.move_child(message_scene, 0)
	
	message_slots.append(message_scene)
		
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
	reset_messages()
	wipe_save.emit()
	$WipeSaveDialogue.visible = false
	


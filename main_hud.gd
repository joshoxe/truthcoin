extends CanvasLayer

var shop_manager = null
var game_manager = null
@export var shop_slot_scene: PackedScene
var slots = []

var SHOP_SLOT_X = 1140
var SHOP_SLOT_Y = 150
var SHOP_SLOT_Y_ADDITION = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	$"ButtonContainer/InboxButton".pressed.connect(on_inbox_button_clicked)
	$"ButtonContainer/ShopButton".pressed.connect(on_shop_button_clicked)
	shop_manager = get_tree().root.get_node("Main/ShopManager")
	game_manager = get_tree().root.get_node("Main/GameManager")

	for miner in shop_manager.miners:
		var shop_slot = shop_slot_scene.instantiate()
		shop_slot.position = Vector2(SHOP_SLOT_X, SHOP_SLOT_Y)
		shop_slot.set_miner(miner)
		shop_slot.miner_purchased.connect(on_miner_purchased)
		slots.append(shop_slot)
		$ShopScrollContainer/ShopContainer.add_child(shop_slot)

func on_miner_purchased(miner):
	game_manager.add_purchased_miner(miner)
	
func on_inbox_button_clicked():
	$ShopScrollContainer.visible = false
	$InboxScrollContainer.visible = true
	
func on_shop_button_clicked():
	$InboxScrollContainer.visible = false
	$ShopScrollContainer.visible = true

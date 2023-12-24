extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$"ButtonContainer/InboxButton".pressed.connect(on_inbox_button_clicked)
	$"ButtonContainer/ShopButton".pressed.connect(on_shop_button_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_inbox_button_clicked():
	$ShopScrollContainer.visible = false
	$InboxScrollContainer.visible = true
	
func on_shop_button_clicked():
	$InboxScrollContainer.visible = false
	$ShopScrollContainer.visible = true

extends Area2D

signal clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)
	$CoinSprite.animation_finished.connect(on_coin_sprite_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event is InputEventMouseButton and event.pressed == true:
		clicked.emit()
		show_clicked_animation()
		
func show_clicked_animation():
	$CoinSprite.play('clicked')
	
func spawn_small_cookie():
	
	
func on_coin_sprite_animation_finished():
	if $CoinSprite.animation == 'clicked':
		$CoinSprite.play('default')

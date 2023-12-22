extends Area2D

signal clicked
@export var small_cookie_scene: PackedScene

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
		spawn_small_cookie(event.position)
		show_clicked_animation()
		
func show_clicked_animation():
	if $CoinSprite.is_playing():
		$CoinSprite.stop()
	$CoinSprite.play('clicked')
	
func spawn_small_cookie(pos: Vector2):
	var small_cookie = small_cookie_scene.instantiate()
	small_cookie.position = pos
	
	var main_scene = get_tree().root.get_node("Main")
	main_scene.add_child(small_cookie)
	
func on_coin_sprite_animation_finished():
	if $CoinSprite.animation == 'clicked':
		$CoinSprite.play('default')

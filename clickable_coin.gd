extends Area2D

signal clicked
@export var small_cookie_scene: PackedScene
var amount_earned_label = preload('res://amount_earned_label.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	$CoinSprite.animation_finished.connect(on_coin_sprite_animation_finished)

func on_mouse_entered():
	Input.set_default_cursor_shape(2)

func on_mouse_exited():
	Input.set_default_cursor_shape(0)
	
func on_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event is InputEventMouseButton and event.pressed == true and event.button_mask == 1:
		clicked.emit()
		spawn_small_cookie(event.position)
		show_clicked_animation()
		show_earned_amount(event.position)
		
func show_clicked_animation():
	if $CoinSprite.is_playing():
		$CoinSprite.stop()
	$CoinSprite.play('clicked')

func show_earned_amount(pos):
	# spawn a label with the amount earned
	var label = amount_earned_label.instantiate()
	label.position = pos + Vector2(0, -50)
	label.text = "+%d" % (1 * Player.cursor_click_boost)
	var main_scene = get_tree().root.get_node("Main")
	main_scene.add_child(label)
	
func spawn_small_cookie(pos: Vector2):
	var small_cookie = small_cookie_scene.instantiate()
	small_cookie.position = pos
	
	var main_scene = get_tree().root.get_node("Main")
	main_scene.add_child(small_cookie)
	
func on_coin_sprite_animation_finished():
	if $CoinSprite.animation == 'clicked':
		$CoinSprite.play('default')

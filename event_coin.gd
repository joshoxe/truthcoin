extends Area2D

signal clicked
var falling_coin_scene = preload("res://falling_coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	input_event.connect(on_input_event)
	$CoinSound.finished.connect(on_coin_sound_finished)

func on_coin_sound_finished():
	queue_free()

func on_timer_timeout():
	queue_free()
	
func on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton and event.pressed == true and event.button_mask == 1:
		visible = false
		$CoinSound.play()
		# spawn some falling_coins randomly as if this coin explodes into smaller coins
		for i in range(0, 5):
			var falling_coin = falling_coin_scene.instantiate()
			# add small random offset to the position
			var rand_position = Vector2(randi_range(-10, 10), randi_range(-10, 10))
			var new_position = get_global_position() + rand_position
			falling_coin.position = new_position
			get_parent().add_child(falling_coin)
		clicked.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(0.8, 0.8), 10.0)
	tween.tween_callback(queue_free)



extends TextureRect

func _physics_process(delta):
	if position.y < 0:
		position.y += 10
	else:
		var timer = Timer.new()
		timer.set_wait_time(5.0)
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0)
		tween.tween_callback(queue_free)


func set_event_text(text: String):
	$EventLabel.text = text

func set_popup_y(new_y:int):
	position.y = new_y

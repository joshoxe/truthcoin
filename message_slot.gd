extends TextureRect

var message: Message
signal clicked(message: Message)

func _ready():
	$Clickable.input_event.connect(on_input_event)

func on_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event is InputEventMouseButton and event.pressed == true and event.button_mask == 1:
		clicked.emit(message)

func display_message_as_unread():
	$FromLabel.text = "[b]%s[/b]" % message.from
	$SubjectLabel.text = "[b]%s[/b]" % message.subject
	
func display_message_as_read():
	$FromLabel.text = ""
	$SubjectLabel.text = ""
	$FromLabel.text = "[font_size=24]%s[/font_size]" % message.from
	$SubjectLabel.text = "[font_size=24]%s[/font_size]" % message.subject

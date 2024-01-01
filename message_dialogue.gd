extends TextureRect

var message: Message

func _ready():
	$CloseButton.pressed.connect(on_close_button_clicked)
	
func on_close_button_clicked():
	visible = false

func display_message():
	$FromLabel.text = message.from
	$SubjectLabel.text = message.subject
	$ContentLabel.text = message.content

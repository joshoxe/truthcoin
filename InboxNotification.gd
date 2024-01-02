extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	MessageManager.new_message.connect(on_new_message)
	MessageManager.message_read.connect(on_message_read)
	calculate_notifications()

func on_new_message(message):
	calculate_notifications()
	
func on_message_read(message):
	calculate_notifications()

func calculate_notifications():
	if MessageManager.inbox.size() == MessageManager.read.size():
		visible = false
	else:
		visible = true
		$NotificationLabel.text = str(MessageManager.inbox.size() - MessageManager.read.size())

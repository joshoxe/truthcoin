class_name Message

var id: int
var from: String
var subject: String
var content: String
var coin_trigger: int

func save():
	return {
		"id": id,
		"from": from,
		"subject": subject,
		"content": content,
		"coin_trigger": coin_trigger
	}

func load(message_data: Dictionary):
	for i in message_data.keys():
		set(i, message_data[i])

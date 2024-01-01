class_name NewsArticle

var id: int
var news: String
var coin_trigger: int

func save():
	return {
		"id": id,
		"news": news,
		"coin_trigger": coin_trigger
	}

func load(news_data: FileAccess):
	for i in news_data.keys():
		if i == "upgrade_trigger":
			continue
		set(i, news_data[i])

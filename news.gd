class_name News extends Node

var message: String
var coins_start: int
var coins_end: int

func load(data):
  message = data["message"]
  coins_start = data["coins_start"]
  coins_end = data["coins_end"]

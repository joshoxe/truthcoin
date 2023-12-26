class_name ShopManager extends Node

var miners = Array()

func _ready():
	var miner = Miner.new()
	miner.miner_name = "Gramps Crypto Rig"
	miner.base_cost = 20
	miner.cost_multiplier = 1.2
	miner.description = "An old-timer with an ancient PC, Gramps mines Truthcoins at his own steady pace."
	miner.earn_rate = 0.1
	miner.image_path = "res://assets/sprites/grandpa.png"
	miners.append(miner)
	
	var miner2 = Miner.new()
	miner2.miner_name = "The Whiz Kid"
	miner2.base_cost = 100
	miner2.cost_multiplier = 1.5
	miner2.description = "A bright, curious youngster armed with a laptop and a knack for algorithms."
	miner2.earn_rate = 0.5
	miner2.image_path = "res://assets/sprites/kid.png"
	miners.append(miner2)

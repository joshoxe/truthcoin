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

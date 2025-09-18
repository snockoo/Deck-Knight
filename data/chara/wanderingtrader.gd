extends Node2D
signal health_changed(new_hp)

var display_name: String = "Wandering Trader"
var max_hp: float = 280
var desc: String = "(Normal)\n A trader and his partner wandering the lands, trying to find any customers suited for his wares. Has a variety of useful items."
@export var portrait: Texture2D = load("res://assets/portraits/WanderingTrader.png")
@export var border: Texture2D = load("res://assets/portraits/WoodPortrait.png")
# Use a setter to emit the signal whenever hp changes.
var hp: float = max_hp:
	set(value):
		# Clamp the value to ensure it doesn't go below 0 or above max_hp.
		hp = clamp(value, 0, max_hp)
		# Emit the signal with the new health value.
		health_changed.emit(hp)
var shield: float = 0
var burn: float = 0
var poison: float = 0
var regen: float = 0
# Example deck
var healingpotion: Card = load("res://data/cards/HealingPotion.tres")
var pelt: Card = load("res://data/cards/Pelt.tres")
var dagger: Card = load("res://data/cards/Dagger.tres")
var restocker: Card = load("res://data/cards/Restocker.tres")
var buckler: Card = load("res://data/cards/Buckler.tres")
var deck: Array[Card] = [pelt, dagger, buckler, healingpotion, restocker]

func is_alive() -> bool:
	return hp > 0

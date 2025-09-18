extends Node2D
signal health_changed(new_hp)

var display_name: String = "Potion Seller"
var max_hp: float = 250
var desc: String = "(Normal)\n A potion seller trying to coerce you into buying his potion goods. Has many different kinds of potions."
@export var portrait: Texture2D = load("res://assets/portraits/PotionSeller.png")
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
var dissolvepotion: Card = load("res://data/cards/DissolvePotion.tres")
var firepotion: Card = load("res://data/cards/FirePotion.tres")
var noxiouspotion: Card = load("res://data/cards/NoxiousPotion.tres")
var restocker: Card = load("res://data/cards/Restocker.tres")
var deck: Array[Card] = [dissolvepotion, firepotion, noxiouspotion, restocker]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Hunter Merchant"
var max_hp: float = 1000
var desc: String = "(Normal)\n A merchant but also a hunter. Sells many different kinds of skin and fur."
@export var portrait: Texture2D = load("res://assets/portraits/HunterMerchant.png")
@export var border: Texture2D = load("res://assets/portraits/MountPortrait.png")
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
var pelt: Card = load("res://data/cards/Pelt.tres")
var trollskin: Card = load("res://data/cards/TrollSkin.tres")
var longbow: Card = load("res://data/cards/Longbow.tres")
var bearskin: Card = load("res://data/cards/BearSkin.tres")
var snowfur: Card = load("res://data/cards/SnowFur.tres")
var deck: Array[Card] = [pelt,trollskin,trollskin,snowfur,bearskin,longbow]

func is_alive() -> bool:
	return hp > 0

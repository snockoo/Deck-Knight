extends Node2D
signal health_changed(new_hp)

var display_name: String = "Royal Knight"
var max_hp: float = 1000
var desc: String = "(Elite)\n A royal knight, a knight that has been acknowledged by the king and guards the castle."
@export var portrait: Texture2D = load("res://assets/portraits/RoyalKnight.png")
@export var border: Texture2D = load("res://assets/portraits/StonePortrait.png")
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
var royalhelmet: Card = load("res://data/cards/RoyalHelmet.tres")
var royalarmor: Card = load("res://data/cards/RoyalArmor.tres")
var royalmedal: Card = load("res://data/cards/RoyalMedal.tres")
var claymore: Card = load("res://data/cards/Claymore.tres")
var deck: Array[Card] = [claymore,royalhelmet,royalarmor,royalmedal]

func is_alive() -> bool:
	return hp > 0

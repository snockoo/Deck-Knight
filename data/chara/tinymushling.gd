extends Node2D
signal health_changed(new_hp)

var display_name: String = "Tiny Mushling"
var max_hp: float = 120
var desc: String = "(Normal)\n A tiny mushling, seems harmless."
@export var portrait: Texture2D = load("res://assets/portraits/TinyMushling.png")
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
var pinkflower: Card = load("res://data/cards/PinkFlower.tres")
var mushlingcap: Card = load("res://data/cards/MushlingCap.tres")
var mushlingskin: Card = load("res://data/cards/MushlingSkin.tres")
var deck: Array[Card] = [pinkflower,mushlingcap,mushlingskin]

func is_alive() -> bool:
	return hp > 0

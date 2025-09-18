extends Node2D
signal health_changed(new_hp)

var display_name: String = "Green Ogre"
var max_hp: float = 600
var desc: String = "(Elite)\n A giant green ogre that has a lot of health. Very slow but hard-hitting, and a small shield sustain that can also buff damage."
@export var portrait: Texture2D = load("res://assets/portraits/GreenOgre.png")
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
var ogreclub: Card = load("res://data/cards/OgreClub.tres")
var hornedhelmet: Card = load("res://data/cards/HornedHelmet.tres")
var deck: Array[Card] = [ogreclub, hornedhelmet]

func is_alive() -> bool:
	return hp > 0

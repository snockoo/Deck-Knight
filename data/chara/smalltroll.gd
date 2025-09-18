extends Node2D
signal health_changed(new_hp)

var display_name: String = "Small Mountain Troll"
var max_hp: float = 1000
var desc: String = "(Normal)\n A small mountain troll with two tusks holding a stone club, looking frenzied, seems like it has lost its way from its own tribe."
@export var portrait: Texture2D = load("res://assets/portraits/SmallMountainTroll.png")
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
var stoneclub: Card = load("res://data/cards/StoneClub.tres")
var trollskin: Card = load("res://data/cards/TrollSkin.tres")
var smalltroll: Card = load("res://data/cards/SmallTroll.tres")
var deck: Array[Card] = [trollskin,stoneclub,smalltroll,trollskin]

func is_alive() -> bool:
	return hp > 0

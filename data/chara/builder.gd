extends Node2D
signal health_changed(new_hp)

var display_name: String = "Builder"
var max_hp: float = 850
var desc: String = "(Normal)\n A house builder of the city. Would you like to get a property?"
@export var portrait: Texture2D = load("res://assets/portraits/Builder.png")
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
var buildinghammer: Card = load("res://data/cards/BuildingHammer.tres")
var smallhouse: Card = load("res://data/cards/SmallHouse.tres")
var mediumhouse: Card = load("res://data/cards/MediumHouse.tres")
var deck: Array[Card] = [buildinghammer, smallhouse, mediumhouse]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "City Watchtower"
var max_hp: float = 800
var desc: String = "(Normal)\n A large city watchtower with archers keeping a lookout in the middle of the city. Any wrongdoing will get alerted."
@export var portrait: Texture2D = load("res://assets/portraits/CityWatchtower.png")
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
var watchtower: Card = load("res://data/cards/Watchtower.tres")
var restocker: Card = load("res://data/cards/Restocker.tres")
var shortbow: Card = load("res://data/cards/Shortbow.tres")
var longbow: Card = load("res://data/cards/Longbow.tres")
var deck: Array[Card] = [shortbow, watchtower, longbow, restocker]

func is_alive() -> bool:
	return hp > 0

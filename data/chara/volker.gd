extends Node2D
signal health_changed(new_hp)

var display_name: String = "Volker, Siege Architect"
var max_hp: float = 700
var desc: String = "(Miniboss)\n The dwarf that forsees the completion of the city's siege machines."
@export var portrait: Texture2D = load("res://assets/portraits/Volker.png")
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
var volkerhammer: Card = load("res://data/cards/VolkerHammer.tres")
var catapult: Card = load("res://data/cards/Catapult.tres")
var mantlets: Card = load("res://data/cards/Mantlets.tres")
var spanner: Card = load("res://data/cards/Spanner.tres")
var reloader: Card = load("res://data/cards/Reloader.tres")
var deck: Array[Card] = [volkerhammer,catapult,mantlets,spanner,reloader]

func is_alive() -> bool:
	return hp > 0

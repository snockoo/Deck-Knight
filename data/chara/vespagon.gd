extends Node2D
signal health_changed(new_hp)

var display_name: String = "Vespagon"
var max_hp: float = 500
var desc: String = "(Miniboss)\n A giant mix of mosquito and bee like bug with a big stinger and sharp claw-like appendages. Even a sting could slowly take a soldier's life."
@export var portrait: Texture2D = load("res://assets/portraits/Vespagon.png")
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
var insectwings: Card = load("res://data/cards/InsectWings.tres")
var insectclaws: Card = load("res://data/cards/InsectClaws.tres")
var vespagonstinger: Card = load("res://data/cards/VespagonStinger.tres")
var vespagonproboscis: Card = load("res://data/cards/VespagonProboscis.tres")
var deck: Array[Card] = [insectwings, vespagonproboscis, insectclaws, vespagonstinger, insectwings]

func is_alive() -> bool:
	return hp > 0

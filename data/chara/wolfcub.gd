extends Node2D
signal health_changed(new_hp)

var display_name: String = "Wolf Cub"
var max_hp: float = 80
var desc: String = "(Normal)\n An aggressive wolf cub attacking rapidly with their fangs."
@export var portrait: Texture2D = load("res://assets/portraits/WolfCub.png")
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
var fang: Card = load("res://data/cards/Fang.tres")
var pelt: Card = load("res://data/cards/Pelt.tres")
var deck: Array[Card] = [pelt,fang,fang]

func is_alive() -> bool:
	return hp > 0

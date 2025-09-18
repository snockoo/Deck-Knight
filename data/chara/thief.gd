extends Node2D
signal health_changed(new_hp)

var display_name: String = "Thief"
var max_hp: float = 200
var desc: String = "(Normal)\n An amateur thief with cloak and daggers plus a sneaky poison trick up his sleeve."
@export var portrait: Texture2D = load("res://assets/portraits/Thief.png")
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
var dagger: Card = load("res://data/cards/Dagger.tres")
var cloak: Card = load("res://data/cards/Cloak.tres")
var viperextract: Card = load("res://data/cards/ViperExtract.tres")
var deck: Array[Card] = [dagger, cloak, dagger,viperextract]

func is_alive() -> bool:
	return hp > 0

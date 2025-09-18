extends Node2D
signal health_changed(new_hp)

var display_name: String = "Squire"
var max_hp: float = 350
var desc: String = "(Normal)\n A squire that grows in power the longer the battle goes on."
@export var portrait: Texture2D = load("res://assets/portraits/Squire.png")
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
var trainingsword: Card = load("res://data/cards/TrainingSword.tres")
var squire: Card = load("res://data/cards/Squire.tres")
var buckler: Card = load("res://data/cards/Buckler.tres")
var deck: Array[Card] = [trainingsword, squire, buckler]

func is_alive() -> bool:
	return hp > 0

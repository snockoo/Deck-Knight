extends Node2D
signal health_changed(new_hp)

var display_name: String = "Engineer"
var max_hp: float = 800
var desc: String = "(Normal)\n A city engineer proudly showing a mantlet that he made on his side."
@export var portrait: Texture2D = load("res://assets/portraits/Engineer.png")
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
var spanner: Card = load("res://data/cards/Spanner.tres")
var goggles: Card = load("res://data/cards/Goggles.tres")
var mantlet: Card = load("res://data/cards/Mantlets.tres")
var hammer: Card = load("res://data/cards/BuildingHammer.tres")
var deck: Array[Card] = [spanner, goggles, mantlet, hammer]

func is_alive() -> bool:
	return hp > 0

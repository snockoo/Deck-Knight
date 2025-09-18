extends Node2D
signal health_changed(new_hp)

var display_name: String = "Goatfolk Raiders"
var max_hp: float = 1100
var desc: String = "(Normal)\n The goat-folks are masters of the craggy terrain. They live in crude, fortified camps in high mountain passes and prey on merchants and travelers who must pass through."
@export var portrait: Texture2D = load("res://assets/portraits/Goatfolk.png")
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
var goatfolkraider: Card = load("res://data/cards/GoatfolkRaider.tres")
var deck: Array[Card] = [goatfolkraider,goatfolkraider,goatfolkraider,goatfolkraider,goatfolkraider]

func is_alive() -> bool:
	return hp > 0

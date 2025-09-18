extends Node2D
signal health_changed(new_hp)

var display_name: String = "Cult of the Dragon"
var max_hp: float = 1000
var desc: String = "(Normal)\n A faction of deranged humans, possibly exiled or seeking power."
@export var portrait: Texture2D = load("res://assets/portraits/DragonCult.png")
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
var firepit: Card = load("res://data/cards/FirePit.tres")
var firedagger: Card = load("res://data/cards/FireDagger.tres")
var dragoncultist: Card = load("res://data/cards/DragonCultist.tres")
var fireball: Card = load("res://data/cards/Fireball.tres")
var deck: Array[Card] = [dragoncultist,firedagger,firepit,fireball,dragoncultist]

func is_alive() -> bool:
	return hp > 0

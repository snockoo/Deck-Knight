extends Node2D
signal health_changed(new_hp)

var display_name: String = "The Ebon Ram"
var max_hp: float = 500
var desc: String = "(Rare)\n The Ebon Ram is a sleek, black-furred goat with massive, twisted horns that spiral upward like a corkscrew. Its eyes glow with a faint, malevolent red light."
@export var portrait: Texture2D = load("res://assets/portraits/EbonRam.png")
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
var ebonram: Card = load("res://data/cards/EbonRam.tres")
var ebonpelt: Card = load("res://data/cards/EbonPelt.tres")
var dragoncultist: Card = load("res://data/cards/DragonCultist.tres")
var fireball: Card = load("res://data/cards/Fireball.tres")
var deck: Array[Card] = [dragoncultist,ebonram,ebonpelt,fireball]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Whispering Fugitive"
var max_hp: float = 500
var desc: String = "(Rare)\n A man broken by his time in the dungeon. His most notable feature is his constant, frantic whispering."
@export var portrait: Texture2D = load("res://assets/portraits/WhisperingFugitive.png")
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
var rottingkey: Card = load("res://data/cards/RottingKey.tres")
var cloak: Card = load("res://data/cards/Cloak.tres")
var festeringbloom: Card = load("res://data/cards/FesteringBloom.tres")
var deck: Array[Card] = [festeringbloom,rottingkey,cloak,festeringbloom]

func is_alive() -> bool:
	return hp > 0

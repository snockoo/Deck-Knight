extends Node2D
signal health_changed(new_hp)

var display_name: String = "Pyromaniac"
var max_hp: float = 350
var desc: String = "(Elite)\n A crazy villager looking to prove a point. Seems to want to burn the entire forest down."
@export var portrait: Texture2D = load("res://assets/portraits/Pyromaniac.png")
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
var firepit: Card = load("res://data/cards/FirePit.tres")
var firepotion: Card = load("res://data/cards/FirePotion.tres")
var fireball: Card = load("res://data/cards/Fireball.tres")
var deck: Array[Card] = [firepit, fireball, firepotion]

func is_alive() -> bool:
	return hp > 0

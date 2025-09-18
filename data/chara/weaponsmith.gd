extends Node2D
signal health_changed(new_hp)

var display_name: String = "Weaponsmith"
var max_hp: float = 700
var desc: String = "(Normal)\n A city weaponsmith forging an iron sword. Many different kinds of weapon showcased in the background. Some say he's related to the armorsmith."
@export var portrait: Texture2D = load("res://assets/portraits/Weaponsmith.png")
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
var sturdysword: Card = load("res://data/cards/SturdySword.tres")
var rapier: Card = load("res://data/cards/Rapier.tres")
var dagger: Card = load("res://data/cards/Dagger.tres")
var polish: Card = load("res://data/cards/Polish.tres")
var weaponsmith: Card = load("res://data/cards/Weaponsmith.tres")
var deck: Array[Card] = [sturdysword,rapier,dagger,polish,weaponsmith]

func is_alive() -> bool:
	return hp > 0

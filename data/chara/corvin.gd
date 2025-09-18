extends Node2D
signal health_changed(new_hp)

var display_name: String = "Corvin, Scrivener's Shadow"
var max_hp: float = 1300
var desc: String = "(Miniboss)\n Once a respected scrivener in the city's grand library. But the endless scrolls and forgotten tomes held more than just history, they held whispers of forbidden knowledge."
@export var portrait: Texture2D = load("res://assets/portraits/Corvin.png")
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
var warlockrobe: Card = load("res://data/cards/WarlockRobe.tres")
var ashenfireball: Card = load("res://data/cards/AshenFireball.tres")
var forbiddenmanuscript: Card = load("res://data/cards/ForbiddenManuscript.tres")
var purplemist: Card = load("res://data/cards/PurpleMist.tres")
var firepotion: Card = load("res://data/cards/FirePotion.tres")
var regenpotion: Card = load("res://data/cards/RegenPotion.tres")
var deck: Array[Card] = [purplemist,ashenfireball,forbiddenmanuscript,warlockrobe,ashenfireball,purplemist]

func is_alive() -> bool:
	return hp > 0

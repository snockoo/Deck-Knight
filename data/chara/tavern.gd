extends Node2D
signal health_changed(new_hp)

var display_name: String = "The Tavern"
var max_hp: float = 850
var desc: String = "(Miniboss)\n A bustling tavern in the city filled with laughter and song, many people from different professions gather here just to drink the night away."
@export var portrait: Texture2D = load("res://assets/portraits/Tavern.png")
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
var tavern: Card = load("res://data/cards/Tavern.tres")
var tavernkeep: Card = load("res://data/cards/TheTavernkeep.tres")
var bard: Card = load("res://data/cards/Bard.tres")
var restocker: Card = load("res://data/cards/Restocker.tres")
var squire: Card = load("res://data/cards/Squire.tres")
var deck: Array[Card] = [tavern,tavernkeep,bard,restocker,squire]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Cleric"
var max_hp: float = 700
var desc: String = "(Normal)\n A cleric following the path of healing, believes anyone is allowed to be healed."
@export var portrait: Texture2D = load("res://assets/portraits/Cleric.png")
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
var holysymbol: Card = load("res://data/cards/HolySymbol.tres")
var prayerbook: Card = load("res://data/cards/HealBook.tres")
var holywater: Card = load("res://data/cards/HolyWater.tres")
var clericrobe: Card = load("res://data/cards/ClericRobe.tres")
var deck: Array[Card] = [holysymbol,clericrobe,holywater,prayerbook]

func is_alive() -> bool:
	return hp > 0

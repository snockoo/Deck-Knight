extends Node2D
signal health_changed(new_hp)

var display_name: String = "Alchemist"
var max_hp: float = 700
var desc: String = "(Normal)\n An alchemist that specializes in making many different kinds of poison."
@export var portrait: Texture2D = load("res://assets/portraits/Alchemist.png")
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
var noxiouspotion: Card = load("res://data/cards/NoxiousPotion.tres")
var alembic: Card = load("res://data/cards/Alembic.tres")
var viperextract: Card = load("res://data/cards/ViperExtract.tres")
var deck: Array[Card] = [noxiouspotion,alembic,viperextract,noxiouspotion]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Armorsmith"
var max_hp: float = 500
var desc: String = "(Normal)\n A city armorsmith forging armor every day. If you need armor get it here. Some say he's related to the weaponsmith."
@export var portrait: Texture2D = load("res://assets/portraits/Armorsmith.png")
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
var chainarmor: Card = load("res://data/cards/ChainArmor.tres")
var leatherarmor: Card = load("res://data/cards/LeatherArmor.tres")
var leathercap: Card = load("res://data/cards/LeatherCap.tres")
var leatherboots: Card = load("res://data/cards/LeatherBoots.tres")
var armorsmith: Card = load("res://data/cards/Armorsmith.tres")
var deck: Array[Card] = [chainarmor,leathercap,leatherarmor,leatherboots,armorsmith]

func is_alive() -> bool:
	return hp > 0

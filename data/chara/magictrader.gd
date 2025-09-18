extends Node2D
signal health_changed(new_hp)

var display_name: String = "Magic Item Trader"
var max_hp: float = 700
var desc: String = "(Normal)\n A magic item trader wandering the city. Has many different kinds of magic items for sale like spell scrolls, staffs, and wands."
@export var portrait: Texture2D = load("res://assets/portraits/MagicItemTrader.png")
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
var wand: Card = load("res://data/cards/Wand.tres")
var wizardstaff: Card = load("res://data/cards/WizardStaff.tres")
var fireballscroll: Card = load("res://data/cards/FireballScroll.tres")
var lightningscroll: Card = load("res://data/cards/LightningStrikeScroll.tres")
var restocker: Card = load("res://data/cards/Restocker.tres")
var deck: Array[Card] = [wand,wizardstaff, fireballscroll, lightningscroll, restocker]

func is_alive() -> bool:
	return hp > 0

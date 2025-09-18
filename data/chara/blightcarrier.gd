extends Node2D
signal health_changed(new_hp)

var display_name: String = "The Blight Carriers"
var max_hp: float = 450
var desc: String = "(Secret Miniboss)\n This creature is not a single, massive beast, but a sickening amalgamation of dozens of rats, all fused together by the grotesque power of the \"Festering Bloom.\" They were once normal dungeon rats, but their proximity to the blight's source has turned them into a single, writhing, collective nightmare."
@export var portrait: Texture2D = load("res://assets/portraits/BlightCarrier.png")
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
var blightcarrier: Card = load("res://data/cards/BlightCarrier.tres")
var fungalgrowth: Card = load("res://data/cards/FungalGrowth.tres")
var festeringbloom: Card = load("res://data/cards/FesteringBloom.tres")
var deck: Array[Card] = [festeringbloom,blightcarrier,fungalgrowth,blightcarrier,blightcarrier]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Frost Giant"
var max_hp: float = 1000
var desc: String = "(Normal)\n More intelligent and powerful than trolls, these giants are masters of cold and ice magic."
@export var portrait: Texture2D = load("res://assets/portraits/FrostGiant.png")
@export var border: Texture2D = load("res://assets/portraits/MountPortrait.png")
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
var frozenbludgeon: Card = load("res://data/cards/FrozenBludgeon.tres")
var frostgiantskin: Card = load("res://data/cards/FrostGiantSkin.tres")
var icicle: Card = load("res://data/cards/Icicle.tres")
var giantbelt: Card = load("res://data/cards/GiantBelt.tres")
var snowfur: Card = load("res://data/cards/SnowFur.tres")
var deck: Array[Card] = [icicle,frozenbludgeon,frostgiantskin,giantbelt,snowfur]

func is_alive() -> bool:
	return hp > 0

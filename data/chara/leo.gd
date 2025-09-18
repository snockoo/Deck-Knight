extends Node2D
signal health_changed(new_hp)

var display_name: String = "Leo, Little Prince"
var max_hp: float = 525
var desc: String = "(Miniboss)\n A short but powerful figure in the city, brings his most loyal guards with him. Unusual for him to take a stroll on the streets."
@export var portrait: Texture2D = load("res://assets/portraits/Leo.png")
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
var smallcrossbow: Card = load("res://data/cards/SmallCrossbow.tres")
var royalmedal: Card = load("res://data/cards/RoyalMedal.tres")
var littleprince: Card = load("res://data/cards/LittlePrince.tres")
var royalguard: Card = load("res://data/cards/RoyalGuard.tres")
var deck: Array[Card] = [royalguard,royalmedal,littleprince,smallcrossbow,royalguard]

func is_alive() -> bool:
	return hp > 0

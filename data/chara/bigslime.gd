extends Node2D
signal health_changed(new_hp)

var display_name: String = "Big Slime"
var max_hp: float = 250
var desc: String = "(Normal)\n A giant green slime that looks battle-worn with rapid regenerative abilities."
@export var portrait: Texture2D = load("res://assets/portraits/BigSlime.png")
@export var border: Texture2D = load("res://assets/portraits/WoodPortrait.png")
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
var slimeteeth: Card = load("res://data/cards/SlimeTeeth.tres")
var slimebody: Card = load("res://data/cards/SlimeBody.tres")
var slimeeye: Card = load("res://data/cards/SlimeEye.tres")
var deck: Array[Card] = [slimeteeth, slimebody, slimeeye, slimeteeth]

func is_alive() -> bool:
	return hp > 0

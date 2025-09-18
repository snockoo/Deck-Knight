extends Node2D
signal health_changed(new_hp)

var display_name: String = "Boar"
var max_hp: float = 250
var desc: String = "(Normal)\n A quick charging boar that specializes in charging attacks with long cooldown but powerful strikes."
@export var portrait: Texture2D = load("res://assets/portraits/Boar.png")
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
var boartusk: Card = load("res://data/cards/BoarTusks.tres")
var boarhead: Card = load("res://data/cards/BoarHead.tres")
var deck: Array[Card] = [boartusk, boarhead, boartusk]

func is_alive() -> bool:
	return hp > 0

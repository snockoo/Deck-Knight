extends Node2D
signal health_changed(new_hp)

var display_name: String = "Twilight Glade"
var max_hp: float = 750
var desc: String = "(Secret Boss)\n This glade exists in a perpetual state of twilight, where the sky is always a deep purple, and the trees are ancient and gnarled, draped in luminous moss. This place is not inherently evil, but profoundly unnatural and ancient."
@export var portrait: Texture2D = load("res://assets/portraits/TwilightGlade.png")
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
var shardoftwilight: Card = load("res://data/cards/ShardOfTwilight.tres")
var shadowveil: Card = load("res://data/cards/ShadowVeil.tres")
var twilightglade: Card = load("res://data/cards/TwilightGlade.tres")
var shadowwolf: Card = load("res://data/cards/ShadowWolf.tres")
var deck: Array[Card] = [shadowwolf,shadowwolf,twilightglade,shardoftwilight,shadowwolf]

func is_alive() -> bool:
	return hp > 0

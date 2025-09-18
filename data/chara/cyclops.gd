extends Node2D
signal health_changed(new_hp)

var display_name: String = "Cyclops"
var max_hp: float = 1500
var desc: String = "(Elite)\n A cyclops that wanders the mountain shouldn't be just a simple brute, its solitary existence and immense power can be a source of fear, reverence, or even strange wisdom."
@export var portrait: Texture2D = load("res://assets/portraits/Cyclops.png")
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
var cyclopshammer: Card = load("res://data/cards/CyclopsHammer.tres")
var cyclopseye: Card = load("res://data/cards/CyclopsEye.tres")
var giantbelt: Card = load("res://data/cards/GiantBelt.tres")
var tremor: Card = load("res://data/cards/Tremor.tres")
var deck: Array[Card] = [tremor,cyclopshammer,cyclopseye,giantbelt,tremor]

func is_alive() -> bool:
	return hp > 0

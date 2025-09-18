extends Node2D
signal health_changed(new_hp)

var display_name: String = "Graveyard"
var max_hp: float = 1500
var desc: String = "(Normal)\n A graveyard at the foot of a mountain, filled with gravestones and skeletons that has been resurrected mysteriously."
@export var portrait: Texture2D = load("res://assets/portraits/Graveyard.png")
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
var skeleton: Card = load("res://data/cards/Skeleton.tres")
var graveyard: Card = load("res://data/cards/Graveyard.tres")
var deck: Array[Card] = [skeleton,skeleton,graveyard,skeleton,skeleton]

func is_alive() -> bool:
	return hp > 0

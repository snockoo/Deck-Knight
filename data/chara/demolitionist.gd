extends Node2D
signal health_changed(new_hp)

var display_name: String = "Demolitionist"
var max_hp: float = 1000
var desc: String = "(Normal)\n A master of mechanical traps and explosive devices. They use ingenuity and foresight to control the battlefield from a distance."
@export var portrait: Texture2D = load("res://assets/portraits/Demolitionist.png")
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
var explosivebarrel: Card = load("res://data/cards/ExplosiveBarrel.tres")
var torch: Card = load("res://data/cards/Torch.tres")
var restocker: Card = load("res://data/cards/Restocker.tres")
var blindingbomb: Card = load("res://data/cards/BlindingBomb.tres")
var deck: Array[Card] = [blindingbomb,explosivebarrel,torch,restocker,restocker]

func is_alive() -> bool:
	return hp > 0

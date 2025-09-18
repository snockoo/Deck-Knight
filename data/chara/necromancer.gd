extends Node2D
signal health_changed(new_hp)

var display_name: String = "Necromancer"
var max_hp: float = 1000
var desc: String = "(Normal)\n A necromancer in search of the secret of life by siphoning the life of others."
@export var portrait: Texture2D = load("res://assets/portraits/Necromancer.png")
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
var skullstaff: Card = load("res://data/cards/SkullStaff.tres")
var lifedrain: Card = load("res://data/cards/Lifedrain.tres")
var necrorobe: Card = load("res://data/cards/NecroRobe.tres")
var skeleton: Card = load("res://data/cards/Skeleton.tres")
var deck: Array[Card] = [lifedrain,skullstaff,necrorobe,lifedrain,skeleton]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Harpies"
var max_hp: float = 850
var desc: String = "(Normal)\n Bird humanoids with large wings, they build nests on the highest, most inaccessible peaks. They hunt in the valleys below but their nests are filled with the treasures and belongings of their victims."
@export var portrait: Texture2D = load("res://assets/portraits/Harpies.png")
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
var harpy: Card = load("res://data/cards/Harpy.tres")
var harpynest: Card = load("res://data/cards/HarpyNest.tres")
var windsickle: Card = load("res://data/cards/WindSickle.tres")
var deck: Array[Card] = [windsickle,harpy,harpynest,harpy,harpy,windsickle]

func is_alive() -> bool:
	return hp > 0

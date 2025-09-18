extends Node2D
signal health_changed(new_hp)

var display_name: String = "Eira, Frost Shaman"
var max_hp: float = 1400
var desc: String = "(Miniboss)\n Born high in the frigid peaks of the mountains, this shaman was a child of a reclusive clan that reveres the unforgiving cold. They believe that true power lies not in speed or haste, but in the slow, inevitable force of a glacier."
@export var portrait: Texture2D = load("res://assets/portraits/Eira.png")
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
var glacialcore: Card = load("res://data/cards/GlacialCore.tres")
var permafrostspirit: Card = load("res://data/cards/PermafrostSpirit.tres")
var sustainingicicle: Card = load("res://data/cards/SustainingIcicle.tres")
var rimestaff: Card = load("res://data/cards/RimeStaff.tres")
var icicle: Card = load("res://data/cards/Icicle.tres")
var deck: Array[Card] = [glacialcore,permafrostspirit,sustainingicicle,rimestaff,icicle,glacialcore]

func is_alive() -> bool:
	return hp > 0

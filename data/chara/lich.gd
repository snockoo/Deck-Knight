extends Node2D
signal health_changed(new_hp)

var display_name: String = "Lich"
var max_hp: float = 1100
var desc: String = "(Elite)\n A skeletal figure draped in tattered robes of a bygone academic. His bones are not the pristine white of a newly risen skeleton, but are stained a sickly, phosphorescent green, as if the very air around him has corroded his form."
@export var portrait: Texture2D = load("res://assets/portraits/Lich.png")
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
var necronomicon: Card = load("res://data/cards/Necronomicon.tres")
var ectoplasm: Card = load("res://data/cards/Ectoplasm.tres")
var emerald: Card = load("res://data/cards/Emerald.tres")
var cauldron: Card = load("res://data/cards/Cauldron.tres")
var soulring: Card = load("res://data/cards/SoulRing.tres")
var deck: Array[Card] = [ectoplasm,emerald,necronomicon,cauldron,soulring,ectoplasm]

func is_alive() -> bool:
	return hp > 0

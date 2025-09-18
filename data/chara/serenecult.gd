extends Node2D
signal health_changed(new_hp)

var display_name: String = "The Serene Cult"
var max_hp: float = 500
var desc: String = "(Miniboss)\n A white cult where they specialize in healing others, presents itself as a haven for the sick, the afflicted, and the weary. They are a pacifist cult with a singular, radical belief: all suffering, whether physical, emotional, or spiritual, is a corrupting burden that prevents true enlightenment."
@export var portrait: Texture2D = load("res://assets/portraits/SereneCult.png")
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
var serenemember: Card = load("res://data/cards/SereneMember.tres")
var serenesanctuary: Card = load("res://data/cards/SereneSanctuary.tres")
var deck: Array[Card] = [serenemember,serenemember,serenemember,serenesanctuary]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Earth Golem"
var max_hp: float = 1300
var desc: String = "(Normal)\n Sentient beings made of the mountain's living rock, guarding a hidden temple. They are not inherently evil but will attack anyone they deem unworthy."
@export var portrait: Texture2D = load("res://assets/portraits/EarthGolem.png")
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
var earthgolem: Card = load("res://data/cards/EarthGolem.tres")
var hiddentemple: Card = load("res://data/cards/HiddenTemple.tres")
var earthtotem: Card = load("res://data/cards/EarthTotem.tres")
var deck: Array[Card] = [earthtotem,earthgolem,hiddentemple,earthgolem,earthtotem]

func is_alive() -> bool:
	return hp > 0

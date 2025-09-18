extends Node2D
signal health_changed(new_hp)

var display_name: String = "Viper"
var max_hp: float = 100
var desc: String = "(Normal)\n A medium sized viper, showing its fangs with a drip of poison"
@export var portrait: Texture2D = load("res://assets/portraits/Viper.png")
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
var viperfang: Card = load("res://data/cards/ViperFang.tres")
var viperextract: Card = load("res://data/cards/ViperExtract.tres")
var deck: Array[Card] = [viperfang,viperextract]

func is_alive() -> bool:
	return hp > 0

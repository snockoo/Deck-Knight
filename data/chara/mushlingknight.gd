extends Node2D
signal health_changed(new_hp)

var display_name: String = "Mushling Knight"
var max_hp: float = 300
var desc: String = "(Normal)\n Mushling Knight, equipped for battle with a little mushling helper that can help recover his health."
@export var portrait: Texture2D = load("res://assets/portraits/MushlingKnight.png")
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
var sturdysword: Card = load("res://data/cards/SturdySword.tres")
var leatherarmor: Card = load("res://data/cards/LeatherArmor.tres")
var tinymushling: Card = load("res://data/cards/TinyMushling.tres")
var deck: Array[Card] = [sturdysword,leatherarmor,tinymushling]

func is_alive() -> bool:
	return hp > 0

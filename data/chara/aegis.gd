extends Node2D
signal health_changed(new_hp)

var display_name: String = "Aegis, Verdant Arrow"
var max_hp: float = 600
var desc: String = "(Miniboss)\n A magical hunter using a longbow that keeps the forest in balance, he can sometimes hunt animals or sometimes even humans who threaten to throw the forest into imbalance, he uses his longbow to snipe and has magical flying arrows that he can control by his side."
@export var portrait: Texture2D = load("res://assets/portraits/Aegis.png")
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
var aegislongbow: Card = load("res://data/cards/AegisLongbow.tres")
var magicarrow: Card = load("res://data/cards/MagicArrow.tres")
var deck: Array[Card] = [magicarrow, magicarrow, aegislongbow, magicarrow, magicarrow]

func is_alive() -> bool:
	return hp > 0

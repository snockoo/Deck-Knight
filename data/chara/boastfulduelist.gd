extends Node2D
signal health_changed(new_hp)

var display_name: String = "Boastful Duelist"
var max_hp: float = 400
var desc: String = "(Normal)\n An upcoming star in dueling, boasting about his skills. Very nimble and quick"
@export var portrait: Texture2D = load("res://assets/portraits/BoastfulDuelist.png")
@export var border: Texture2D = load("res://assets/portraits/StonePortrait.png")
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
var rapier: Card = load("res://data/cards/Rapier.tres")
var polish: Card = load("res://data/cards/Polish.tres")
var leatherboots: Card = load("res://data/cards/LeatherBoots.tres")
var deck: Array[Card] = [rapier, polish, leatherboots, leatherboots]

func is_alive() -> bool:
	return hp > 0

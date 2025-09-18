extends Node2D
signal health_changed(new_hp)

var display_name: String = "Adventurer"
var max_hp: float = 750
var desc: String = "(Normal)\n An adventurer ready to explore. Has many useful tools that might come in handy."
@export var portrait: Texture2D = load("res://assets/portraits/Adventurer.png")
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
var torch: Card = load("res://data/cards/Torch.tres")
var sturdysword: Card = load("res://data/cards/SturdySword.tres")
var healingpotion: Card = load("res://data/cards/HealingPotion.tres")
var leatherarmor: Card = load("res://data/cards/LeatherArmor.tres")
var ropes: Card = load("res://data/cards/Ropes.tres")
var lantern: Card = load("res://data/cards/Lantern.tres")
var deck: Array[Card] = [torch,sturdysword,healingpotion,leatherarmor,ropes,lantern]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Executioner"
var max_hp: float = 900
var desc: String = "(Elite)\n A city executioner. Punishing those who did crimes bad enough to deserve death. Fear spreads in public executions."
@export var portrait: Texture2D = load("res://assets/portraits/Executioner.png")
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
var executioneraxe: Card = load("res://data/cards/ExecutionerAxe.tres")
var guillotine: Card = load("res://data/cards/Guillotine.tres")
var executionermask: Card = load("res://data/cards/ExecutionerMask.tres")
var dissolvepotion: Card = load("res://data/cards/DissolvePotion.tres")
var deck: Array[Card] = [executioneraxe,executionermask,dissolvepotion,guillotine]

func is_alive() -> bool:
	return hp > 0

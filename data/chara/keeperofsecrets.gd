extends Node2D
signal health_changed(new_hp)

var display_name: String = "Keeper of Secrets"
var max_hp: float = 1000
var desc: String = "(S■cre■ Fi■a■ Bo■s)\n The ■■■■■■ is not ■■■■■■■■ malic■ous but ■■ the anci■nt guar■ian of the ■■■■■■■■ Glade a■d the ■■■■■■■ it hol■s. It ■■■ creat■d by the ■■■■ pr■■ordial fo■ces that ■■■■■■ the Gl■om ■■alker and t■■ Glade ■■■■■■."
@export var portrait: Texture2D = load("res://assets/portraits/KeeperOfSecrets.png")
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
var shardoftwilight: Card = load("res://data/cards/ShardOfTwilight.tres")
var keeperofsecrets: Card = load("res://data/cards/KeeperOfSecrets.tres")
var twilightglade: Card = load("res://data/cards/TwilightGlade.tres")
var shadowwolf: Card = load("res://data/cards/ShadowWolf.tres")
var deck: Array[Card] = [shadowwolf,twilightglade,shardoftwilight,keeperofsecrets,twilightglade,shadowwolf]

func is_alive() -> bool:
	return hp > 0

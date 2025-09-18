extends Node2D
signal health_changed(new_hp)

var display_name: String = "Gloom Stalker"
var max_hp: float = 500
var desc: String = "(Rare)\n A creature of shadow and moss, resembling a corrupted deer or stag, but far larger and more ethereal."
@export var portrait: Texture2D = load("res://assets/portraits/GloomStalker.png")
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
var pinkflower: Card = load("res://data/cards/PinkFlower.tres")
var shadowveil: Card = load("res://data/cards/ShadowVeil.tres")
var deck: Array[Card] = [pinkflower,shardoftwilight,shadowveil,pinkflower]

func is_alive() -> bool:
	return hp > 0

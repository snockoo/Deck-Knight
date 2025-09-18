extends Node2D
signal health_changed(new_hp)

var display_name: String = "Oswald, Architect of Rot"
var max_hp: float = 600
var desc: String = "(Secret Final Boss)\n He is a man who was once a master craftsman, but who has been slowly consumed by his own creation. He has survived, but his body and mind have succumbed to the dungeon's corrupting influence. The very hammer he used to lay the foundation of the castle, it is now completely rusted and covered in the same fungal growth as his body."
@export var portrait: Texture2D = load("res://assets/portraits/Oswald.png")
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
var blightcarrier: Card = load("res://data/cards/BlightCarrier.tres")
var fungalgrowth: Card = load("res://data/cards/FungalGrowth.tres")
var festeringbloom: Card = load("res://data/cards/FesteringBloom.tres")
var plaguecornerstone: Card = load("res://data/cards/PlagueCornerstone.tres")
var deck: Array[Card] = [festeringbloom,blightcarrier,fungalgrowth,plaguecornerstone,blightcarrier,blightcarrier,blightcarrier]

func is_alive() -> bool:
	return hp > 0

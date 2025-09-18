extends Node2D
signal health_changed(new_hp)

var display_name: String = "Obsidian Golem"
var max_hp: float = 1500
var desc: String = "(Miniboss)\n The Obsidian Golem is the last of the protectors, an impassive, unthinking guardian that has remained motionless for centuries. Its purpose is to protect the Obsidian Shrine—the source of the dragon’s corruption."
@export var portrait: Texture2D = load("res://assets/portraits/ObsidianGolem.png")
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
var obsidiangolem: Card = load("res://data/cards/ObsidianGolem.tres")
var obsidianshrine: Card = load("res://data/cards/ObsidianShrine.tres")
var earthtotem: Card = load("res://data/cards/EarthTotem.tres")
var deck: Array[Card] = [earthtotem,earthtotem,obsidiangolem,obsidianshrine,earthtotem,earthtotem]

func is_alive() -> bool:
	return hp > 0

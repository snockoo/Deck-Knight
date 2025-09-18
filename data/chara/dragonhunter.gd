extends Node2D
signal health_changed(new_hp)

var display_name: String = "The Dragonhunter Crew"
var max_hp: float = 1250
var desc: String = "(Miniboss)\n They are hired by kings and lords, and they view dragons as an ultimate challenge to be overcome with skill and advanced gear. Members are trained in specific roles, from scouting to close-quarters combat."
@export var portrait: Texture2D = load("res://assets/portraits/Dragonhunter.png")
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
var dragonsbane: Card = load("res://data/cards/Dragonsbane.tres")
var dragonhunter: Card = load("res://data/cards/Dragonhunter.tres")
var harpooncrossbow: Card = load("res://data/cards/HarpoonCrossbow.tres")
var obsidianpolish: Card = load("res://data/cards/ObsidianPolisher.tres")
var deck: Array[Card] = [dragonsbane,dragonhunter,dragonhunter,harpooncrossbow,harpooncrossbow,obsidianpolish,obsidianpolish]

func is_alive() -> bool:
	return hp > 0

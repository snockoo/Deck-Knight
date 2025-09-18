extends Node2D
signal health_changed(new_hp)

var display_name: String = "Valerius, King in Black"
var max_hp: float = 2000
var desc: String = "(Boss)\n King Valerius wasn't always a tyrant. He was once a beloved ruler, a man who built the city into a bastion of culture and prosperity. But years ago, a terrible plague began to sweep through his kingdom, and no healer or alchemist could stop it. Desperate, Valerius turned to forbidden knowledge and found a terrible pact with a powerful, malevolent entity."
@export var portrait: Texture2D = load("res://assets/portraits/Valerius.png")
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
var kingscepter: Card = load("res://data/cards/KingScepter.tres") #damage damage burn
var livingarmor: Card = load("res://data/cards/LivingArmor.tres") #combo maxhp
var kingsattendant: Card = load("res://data/cards/KingAttendant.tres") #lifesteal charge weapon
var crimsongrasp: Card = load("res://data/cards/CrimsonGrasp.tres") #lifesteal
var deck: Array[Card] = [kingsattendant,kingsattendant,kingscepter,livingarmor,crimsongrasp,kingsattendant,kingsattendant]

func is_alive() -> bool:
	return hp > 0

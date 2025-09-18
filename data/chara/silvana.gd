extends Node2D
signal health_changed(new_hp)

var display_name: String = "Silvana, Elderwood Guardian"
var max_hp: float = 2000
var desc: String = "(Boss)\n Silvana, she is an ancient druid who has lived for centuries in the heart of the deepest, oldest forest. Her life's purpose has been to protect a sacred place—the Heartwood, a colossal, ancient tree that serves as the life force for the entire forest. This tree is the source of all the area's magic and vitality."
@export var portrait: Texture2D = load("res://assets/portraits/Silvana.png")
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
var elderwood: Card = load("res://data/cards/Elderwood.tres") #shield for every heal regen for every heal
var heartwoodblessing: Card = load("res://data/cards/HeartwoodBlessing.tres") #heal and maxhp charge friend
var verdantamulet: Card = load("res://data/cards/VerdantAmulet.tres") #heal and buff all heal
var thornwhip: Card = load("res://data/cards/Thornwhip.tres") #heal damage slow
var livingroots: Card = load("res://data/cards/LivingRoot.tres") #heal debuff slow
var heartwoodanimals: Card = load("res://data/cards/HeartwoodAnimals.tres") #charge a heal by 4.
var deck: Array[Card] = [heartwoodanimals,heartwoodblessing,verdantamulet,elderwood,thornwhip,livingroots,heartwoodanimals]

func is_alive() -> bool:
	return hp > 0

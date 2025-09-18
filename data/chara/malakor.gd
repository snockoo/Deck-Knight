extends Node2D
signal health_changed(new_hp)

var display_name: String = "Malakor, Ebon Scourge"
var max_hp: float = 1500
var desc: String = "(Boss)\n Malakor is a primordial dragon, a creature not born in a nest but birthed from the very earth itself. It is not driven by a lust for gold or a desire for conquest. Malakor is a parasite, a living conduit of cosmic hunger that has laid dormant for centuries. Its presence is what keeps the mountain’s veins of raw magical energy active, but it feeds on them, slowly draining the life force from the land."
@export var portrait: Texture2D = load("res://assets/portraits/Malakor.png")
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
var dragonheart: Card = load("res://data/cards/DragonHeart.tres") #burn buffer
var meltingectoplasm: Card = load("res://data/cards/MeltingEctoplasm.tres") #burn poison
var dragonwing: Card = load("res://data/cards/DragonWing.tres") #bodypart charger + burn
var malakormaw: Card = load("res://data/cards/MalakorMaw.tres") #lifesteal poison
var malakortail: Card = load("res://data/cards/MalakorTail.tres") #burn poison 
var deck: Array[Card] = [meltingectoplasm,dragonwing,malakormaw,dragonheart,malakortail,dragonwing,meltingectoplasm]

func is_alive() -> bool:
	return hp > 0

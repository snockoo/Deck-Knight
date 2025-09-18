extends Node2D
signal health_changed(new_hp)

var display_name: String = "Grokk, the Rime-hearted"
var max_hp: float = 1500
var desc: String = "(Miniboss)\n Grokk was once a normal mountain troll who lived peacefully in the upper crags. When the dragon's presence began to corrupt the mountain, it infused Grokk's body with a sickly, malevolent form of ice magic. Instead of natural regeneration, he now grows razor-sharp spikes of rime from his flesh as he takes damage."
@export var portrait: Texture2D = load("res://assets/portraits/Grokk.png")
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
var giantbelt: Card = load("res://data/cards/GiantBelt.tres")
var trollskin: Card = load("res://data/cards/TrollSkin.tres")
var grokkclub: Card = load("res://data/cards/GrokkClub.tres")
var rimeheart: Card = load("res://data/cards/RimeHeart.tres")
var bearskin: Card = load("res://data/cards/BearSkin.tres")
var snowfur: Card = load("res://data/cards/SnowFur.tres")
var deck: Array[Card] = [snowfur,trollskin,grokkclub,rimeheart,giantbelt,bearskin]

func is_alive() -> bool:
	return hp > 0

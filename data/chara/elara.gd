extends Node2D
signal health_changed(new_hp)

var display_name: String = "Elara, Mountain Child"
var max_hp: float = 1666
var desc: String = "(Secret Final Boss)\n As the ritual nears its end, the mountain itself begins to shake and groan. Cracks form in the sky, revealing a glimpse of the same dark red energy. The vortex would open into a massive portal, a single, horrifying eye would open in the sky, and the mountain would begin to crumble around them. Cataclysm has come."
@export var portrait: Texture2D = load("res://assets/portraits/Elara.png")
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
var cataclysm: Card = load("res://data/cards/Cataclysm.tres")
var ebonram: Card = load("res://data/cards/EbonRam.tres")
var ebonaltar: Card = load("res://data/cards/EbonAltar.tres")
var elara: Card = load("res://data/cards/Elara.tres")
var driedhusk: Card = load("res://data/cards/DriedHusk.tres")
var crimsonvortex: Card = load("res://data/cards/CrimsonVortex.tres")
var deck: Array[Card] = [ebonram, ebonaltar, cataclysm, elara, crimsonvortex, driedhusk]

func is_alive() -> bool:
	return hp > 0

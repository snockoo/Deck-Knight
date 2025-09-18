extends Node2D
signal health_changed(new_hp)

var display_name: String = "The Ebon Altar"
var max_hp: float = 1000
var desc: String = "(Secret Miniboss)\n At the foot of the altar, the ground has been torn asunder. A massive, gaping chasm splits the earth, a deep wound that bleeds a foul, reddish-black vapor. Within the chasm, you can see not a bottom, but a swirling vortex of pure shadow."
@export var portrait: Texture2D = load("res://assets/portraits/EbonAltar.png")
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
var ebonram: Card = load("res://data/cards/EbonRam.tres")
var ebonaltar: Card = load("res://data/cards/EbonAltar.tres")
var thechasm: Card = load("res://data/cards/TheChasm.tres")
var driedhusk: Card = load("res://data/cards/DriedHusk.tres")
var deck: Array[Card] = [ebonram,ebonaltar,thechasm,driedhusk,driedhusk,driedhusk]

func is_alive() -> bool:
	return hp > 0

extends Node2D
signal health_changed(new_hp)

var display_name: String = "Aurelia, the Arch-alchemist"
var max_hp: float = 750
var desc: String = "(Miniboss)\n The alchemist girl who made the philosopher's stone, the key to vitality and the ingredient for the elixir of life."
@export var portrait: Texture2D = load("res://assets/portraits/Aurelia.png")
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
var philosopherstone: Card = load("res://data/cards/PhilosopherStone.tres")
var elixiroflife: Card = load("res://data/cards/ElixirOfLife.tres")
var noxiouspotion: Card = load("res://data/cards/NoxiousPotion.tres")
var alembic: Card = load("res://data/cards/Alembic.tres")
var firepotion: Card = load("res://data/cards/FirePotion.tres")
var regenpotion: Card = load("res://data/cards/RegenPotion.tres")
var deck: Array[Card] = [noxiouspotion,elixiroflife,philosopherstone,firepotion,regenpotion]

func is_alive() -> bool:
	return hp > 0

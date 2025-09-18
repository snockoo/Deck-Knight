extends Node2D
signal health_changed(new_hp)

var display_name: String = "City Wizard"
var max_hp: float = 750
var desc: String = "(Normal)\n A local wizard that has studied in the arts of magic. Would be glad to teach some spells."
@export var portrait: Texture2D = load("res://assets/portraits/CityWizard.png")
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
var wizardstaff: Card = load("res://data/cards/WizardStaff.tres")
var wizardrobe: Card = load("res://data/cards/WizardRobe.tres")
var fireball: Card = load("res://data/cards/Fireball.tres")
var lightningscroll: Card = load("res://data/cards/LightningStrikeScroll.tres")
var firepotion: Card = load("res://data/cards/FirePotion.tres")
var deck: Array[Card] = [wizardstaff, wizardrobe, fireball,lightningscroll, firepotion]

func is_alive() -> bool:
	return hp > 0

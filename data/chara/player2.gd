extends Node2D
signal health_changed(new_hp)

var display_name: String = GameState.player2name
var max_hp: float = GameState.max_player_hp
var desc: String = "(Normal)\n Player 2"
@export var portrait: Texture2D = load("res://assets/portraits/PlayerKnight.png")
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
var deck: Array[Card] = GameState.pvp_player2_deck

func is_alive() -> bool:
	return hp > 0

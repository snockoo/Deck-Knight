extends Node2D

class_name Player
signal health_changed(new_hp)

var display_name: String = GameState.player1name
var max_hp: float = GameState.max_player_hp
var border: Texture2D = load("res://assets/portraits/WoodPortrait.png")
var portrait: Texture2D = load("res://assets/portraits/PlayerKnight.png")
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

func is_alive() -> bool:
	return hp > 0

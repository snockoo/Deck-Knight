# res://scripts/GameState.gd
extends Node


var player_deck: Array[Card] = []
var allcards: Array[Card] = []

var pvp_player1_deck: Array[Card] = []
var pvp_player2_deck: Array[Card] = []
var player1name = "Player"
var player2name = "Player2"

var lives = 3
var max_player_hp = 250
var deck_limit: int = 2
var current_level = 0
var last_defeated_enemy_deck: Array = []
var current_enemy
var pvpmode = false

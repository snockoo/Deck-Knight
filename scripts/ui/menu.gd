# res://scripts/ui/Menu.gd
extends Control

@onready var start_button = $CenterContainer/VBoxContainer/Start
@onready var pvp_button = $CenterContainer/VBoxContainer/PVP
@onready var guide_button = $CenterContainer/VBoxContainer/Guide
@onready var exit_button = $CenterContainer/VBoxContainer/Exit

var sturdysword: Card = load("res://data/cards/SturdySword.tres")
var claymore: Card = load("res://data/cards/Claymore.tres")
var healprayer: Card = load("res://data/cards/HealPrayer.tres")
var roundshield: Card = load("res://data/cards/RoundShield.tres")
var trainingsword: Card = load("res://data/cards/TrainingSword.tres")
var healbook: Card = load("res://data/cards/HealBook.tres")
var squire: Card = load("res://data/cards/Squire.tres")
var sandstorm: Card = load("res://data/cards/Sandstorm.tres")
var bandage: Card = load("res://data/cards/Bandage.tres")
var buckler: Card = load("res://data/cards/Buckler.tres")
var torch : Card = load("res://data/cards/Torch.tres")
var pelt: Card = load("res://data/cards/Pelt.tres")
var viperfang: Card = load("res://data/cards/ViperFang.tres")
var trollskin: Card = load("res://data/cards/TrollSkin.tres")
var shortbow: Card = load("res://data/cards/Shortbow.tres")

func _ready():
	# Connect the "pressed" signal of the button to a new function.
	start_button.pressed.connect(Callable(self, "_on_start_button_pressed"))
	pvp_button.pressed.connect(Callable(self, "_on_pvp_button_pressed"))
	guide_button.pressed.connect(Callable(self, "_on_guide_button_pressed"))
	exit_button.pressed.connect(Callable(self, "_on_exit_button_pressed"))
	
func _on_start_button_pressed():
	GameState.current_level = 0
	GameState.deck_limit = 2
	GameState.player_deck = []
	GameState.allcards = []
	GameState.max_player_hp = 250
	GameState.lives = 3
	
	#GameState.max_player_hp = 750
	#GameState.deck_limit = 20
	
	# Load original cards
	var starting_cards = [sturdysword,claymore,healprayer,roundshield]
	for cards in starting_cards:
		# Create the duplicated card first
		var duplicated_card = cards.duplicate(true)
		
		# Now, set the original path on the duplicated instance
		duplicated_card.original_resource_path = cards.resource_path
		
		# Add the corrected duplicated card to your GameState
		GameState.allcards.append(duplicated_card)


	# Load the main game scene and change to it.
	get_tree().change_scene_to_file("res://scenes/deckbuilding.tscn")

func _on_pvp_button_pressed():
	get_tree().change_scene_to_file("res://scenes/pvpmenu.tscn")
	
func _on_guide_button_pressed():
	get_tree().change_scene_to_file("res://scenes/guide.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

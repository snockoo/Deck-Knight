extends Control

@onready var reward_container = $VBoxContainer/EnemyDeck
@onready var current_deck = $ScrollContainer/CurrentDeck
var card_ui_scene = preload("res://card_scenes/CardUI.tscn"	)

func _ready():
	# Get a list of unique cards from the enemy's deck
	var enemy_deck_cards = GameState.last_defeated_enemy_deck.duplicate()
	enemy_deck_cards.shuffle()
	
	# Get the top 3 cards from the shuffled deck as rewards
	var rewards = []
	if enemy_deck_cards.size() >= 3:
		rewards = enemy_deck_cards.slice(0, 3)
	else:
		# If the deck is too small, just use all of them
		rewards = enemy_deck_cards

	# Display the reward cards
	for card_data in rewards:
		var card_ui_instance = card_ui_scene.instantiate()
		card_ui_instance.card_data = card_data
		reward_container.add_child(card_ui_instance)

		# Disconnect any old signals to prevent errors
		
		# Connect the clicked signal to handle the player's choice
		card_ui_instance.clicked.connect(Callable(self, "_on_card_selected"))
		
	_display_player_deck()

func _on_card_selected(chosen_card_data):
	# Add the chosen card to the player's deck
	var duplicated_card = chosen_card_data.duplicate(true)
		
	# Now, set the original path on the duplicated instance
	duplicated_card.original_resource_path = chosen_card_data.resource_path
	
	# Add the corrected duplicated card to your GameState
	GameState.allcards.append(duplicated_card)
	# Change the scene back to the deck builder
	get_tree().change_scene_to_file("res://scenes/deckbuilding.tscn")

func _display_player_deck():
	for card_data in GameState.player_deck:
		var card_ui_instance = card_ui_scene.instantiate()
		card_ui_instance.card_data = card_data
		current_deck.add_child(card_ui_instance)

		# Connect the click signal to a new function for buffing
		card_ui_instance.clicked.connect(Callable(self, "_on_player_card_clicked"))

func _on_player_card_clicked(card_data_to_buff):
	# Iterate through the actual deck data in GameState
	for i in range(GameState.player_deck.size()):
		if GameState.player_deck[i] == card_data_to_buff:
			# Randomly select one effect from the card's effects array
			var random_effect = card_data_to_buff.effects.pick_random()
			
			# Buff the selected effect's value based on its type
			var buff_amount = 1
			match random_effect.type:
				"maxhp":
					buff_amount = 25
				"damage":
					buff_amount = 20
				"heal", "shield", "lifesteal":
					buff_amount = 10
				"buff", "debuff", "regen", "poison":
					buff_amount = 2
				"charge", "additive", "ammo_recovery":
					buff_amount = 1
				"burn":
					buff_amount = 3
				"combo_damage":
					if random_effect.buff_type == "damage":
						buff_amount = 10
					if random_effect.buff_type == "shield":
						buff_amount = 5
					if random_effect.buff_type == "burn":
						buff_amount = 1
			
			for effect in GameState.player_deck[i].effects:
				if effect.type == random_effect.type:
					effect.value += buff_amount
			
			
			# Exit the screen after buffing one card
			get_tree().change_scene_to_file("res://scenes/deckbuilding.tscn")
			return

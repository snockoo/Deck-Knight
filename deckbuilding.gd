extends Control

# Battle Button
@onready var battle_button = $Battle
# Battle Button
@onready var retire_button = $Retire
# Reference the HBoxContainer from the scene tree
@onready var card_container = $ScrollContainer/Binder
# Reference the HBoxContainer from the scene tree
@onready var current_deck_container = $ScrollContainer2/CurrentDeck
# Warning Label
@onready var message_label = $Warnings
# Level Counter Label
@onready var level_label = $Level

# Load the CardUI scene
var card_ui_scene = preload("res://CardUI.tscn")

var binder_uis: Array = []  # New: Array for CardUI instances

var selected_cards: Array[Card] = GameState.player_deck # This array will hold the cards the player has selected.
var deck_limit: int = GameState.deck_limit # Set your desired deck size limit here
var current_deck_cost: int = 0

func _ready():
	
	# If the player has a deck already, populate the current deck box
	_populate_current_deck()
	_clear_message()
	
	level_label.text = "Level %d" % (GameState.current_level + 1)
	
	for card_data in GameState.allcards:
		var card_ui_instance = card_ui_scene.instantiate()
		# Set the card data
		card_ui_instance.card_data = card_data
		
		# Add the UI instance to the container
		card_container.add_child(card_ui_instance)
		
		# Connect the CardUI's clicked signal to a new function.
		card_ui_instance.clicked.connect(Callable(self, "_on_card_added"))
		
		binder_uis.append(card_ui_instance)
	
	battle_button.pressed.connect(Callable(self, "_on_battle_button_pressed"))
	retire_button.pressed.connect(Callable(self, "_on_retire_button_pressed"))

func _on_battle_button_pressed():
	if GameState.lives > 0:
		# Pass the selected cards to the global GameState.
		GameState.player_deck = selected_cards
		if GameState.current_level == 14:
			# Change the scene to finish screen for deck saving
			get_tree().change_scene_to_file("res://finishscreen.tscn")
		else:
			# Now, change the scene to the main battle scene.
			get_tree().change_scene_to_file("res://pathselect.tscn")
	else:
		message_label.text = "You have no more Lives!"
		message_label.add_theme_color_override("font_color", Color.RED)
		get_tree().create_timer(2.0).timeout.connect(Callable(self, "_clear_message"))

func _on_retire_button_pressed():
	# Pass the selected cards to the global GameState.
	GameState.player_deck = selected_cards

	get_tree().change_scene_to_file("res://finishscreen.tscn")


func _on_card_added(card_data):
	# Check if the card is already in the selected_cards array
	if selected_cards.has(card_data):
		message_label.text = "Cannot Add Duplicates!"
		# You can use a timer to clear the message after a few seconds
		message_label.add_theme_color_override("font_color", Color.RED)
		get_tree().create_timer(2.0).timeout.connect(Callable(self, "_clear_message"))
		return
	# Check if the deck is within the limit
	if current_deck_cost + card_data.cost > GameState.deck_limit:
		message_label.text = "Deck Cost Limit Reached!"
		message_label.add_theme_color_override("font_color", Color.RED)
		get_tree().create_timer(2.0).timeout.connect(Callable(self, "_clear_message"))
		return
		
	var deck_card_ui_instance = card_ui_scene.instantiate()
	deck_card_ui_instance.card_data = card_data
	
	# Add the clicked card to the selected_cards array.
	selected_cards.append(card_data)
	current_deck_container.add_child(deck_card_ui_instance)
	
	# Add the card's cost to the deck's total cost
	current_deck_cost += card_data.cost

	# Set the new instance to be removable
	deck_card_ui_instance.is_removable = true
	
	# Connect the removed_from_deck signal
	deck_card_ui_instance.removed_from_deck.connect(Callable(self, "_on_card_removed"))

func _clear_message():
	message_label.add_theme_color_override("font_color", Color("#3f3f3f"))
	message_label.text = "Cost Limit: %d, Lives: %d" % [GameState.deck_limit, GameState.lives]
	
func _on_card_removed(card_data):
	# Find and remove the card from the selected_cards array
	selected_cards.erase(card_data)
	current_deck_cost -= card_data.cost
	# Find and remove the CardUI instance from the scene
	for child in current_deck_container.get_children():
		if child.card_data == card_data:
			current_deck_container.remove_child(child)
			child.queue_free() # Safely remove the node from memory
			break # Exit the loop after finding and removing one card
	
	print("Removed %s from deck. Deck size: %d" % [card_data.name, selected_cards.size()])

func _populate_current_deck():
	for card_data in selected_cards:
		var deck_card_ui_instance = card_ui_scene.instantiate()
		deck_card_ui_instance.card_data = card_data
		
		# Cost
		current_deck_cost += card_data.cost
		
		# Set the new instance to be removable
		deck_card_ui_instance.is_removable = true
		
		# Connect the removed_from_deck signal
		deck_card_ui_instance.removed_from_deck.connect(Callable(self, "_on_card_removed"))
		
		current_deck_container.add_child(deck_card_ui_instance)

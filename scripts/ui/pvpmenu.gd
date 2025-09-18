extends Control

@onready var player1_deck_label = $VBoxContainer/DeckStatus1
@onready var player2_deck_label = $VBoxContainer2/DeckStatus2
@onready var start_battle_button = $Start
@onready var back_button = $Back

@onready var player1_file_dialog = $FileDialog1
@onready var player2_file_dialog = $FileDialog2

@onready var player1_deck = $ScrollContainer/Binder
@onready var player2_deck = $ScrollContainer2/Binder2
var card_ui_scene = preload("res://card_scenes/CardUI.tscn")

var pvp_player1_deck: Array[Card] = []
var pvp_player2_deck: Array[Card] = []

var player2

func _ready():
	# Connect signals from UI buttons
	$VBoxContainer/Load1.pressed.connect(Callable(player1_file_dialog, "popup"))
	$VBoxContainer2/Load2.pressed.connect(Callable(player2_file_dialog, "popup"))
	start_battle_button.pressed.connect(Callable(self, "_on_start_battle_pressed"))
	back_button.pressed.connect(Callable(self, "_on_back_pressed"))
	
	# Connect signals from FileDialogs
	player1_file_dialog.file_selected.connect(Callable(self, "_on_player1_file_selected"))
	player2_file_dialog.file_selected.connect(Callable(self, "_on_player2_file_selected"))

func _on_player1_file_selected(path: String):
	pvp_player1_deck = load_deck_from_file(path)
	if pvp_player1_deck:
		# Get the full file name from the path
		var file_name = path.get_file()
		
		# Optionally, get the name without the file extension
		var display_name = file_name.get_basename()
		
		# Now, you can use 'display_name' to update your UI or store it
		player1_deck_label.text = "Deck 1 Loaded: " + display_name
		
		GameState.player1name = display_name
		
	_display_player1_deck()
	_check_if_ready_to_start()

func _on_player2_file_selected(path: String):
	pvp_player2_deck = load_deck_from_file(path)
	if pvp_player2_deck:
		# Get the full file name from the path
		var file_name = path.get_file()
		
		# Optionally, get the name without the file extension
		var display_name = file_name.get_basename()
		
		# Now, you can use 'display_name' to update your UI or store it
		player2_deck_label.text = "Deck 2 Loaded:" + display_name
		
		GameState.player2name = display_name
		
	_display_player2_deck()
	_check_if_ready_to_start()

func load_deck_from_file(file_path: String) -> Array[Card]:
	if not FileAccess.file_exists(file_path):
		print("Error: File not found at ", file_path)
		return []
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var parse_result = JSON.parse_string(json_string)
	if parse_result is not Array:
		print("Error: Invalid deck file format.")
		return []
	
	var deck_dictionaries: Array = parse_result
	var loaded_deck: Array[Card] = []
	
	# Load each card, then re-apply its buffs
	for card_dict in deck_dictionaries:
		# Step 1: Load the base card from the path
		var card_base = load(card_dict.resource_path)
		if not card_base:
			print("Error: Could not load card from path ", card_dict.resource_path)
			continue
			
		# Step 2: Create a duplicate to re-apply buffs
		var card_instance = card_base.duplicate(true)
		
		# Step 3: Re-apply the buffed effects from the saved dictionary
		card_instance.effects = card_dict.effects
		
		# Set the original resource path so you can save this deck again later if needed
		card_instance.original_resource_path = card_dict.resource_path
		
		loaded_deck.append(card_instance)
	
	return loaded_deck

func _display_player1_deck():
	for child in player1_deck.get_children():
		child.queue_free()
	for card_data in pvp_player1_deck:
		var card_ui_instance = card_ui_scene.instantiate()
		card_ui_instance.card_data = card_data
		player1_deck.add_child(card_ui_instance)

func _display_player2_deck():
	for child in player2_deck.get_children():
		child.queue_free()
	for card_data in pvp_player2_deck:
		var card_ui_instance = card_ui_scene.instantiate()
		card_ui_instance.card_data = card_data
		player2_deck.add_child(card_ui_instance)

func _check_if_ready_to_start():
	if not pvp_player1_deck.is_empty() and not pvp_player2_deck.is_empty():
		start_battle_button.disabled = false

func _on_start_battle_pressed():
	GameState.max_player_hp = 1500
	GameState.pvpmode = true
	
	GameState.player_deck = pvp_player1_deck
	GameState.pvp_player2_deck = pvp_player2_deck
	player2 = preload("res://data/chara/player2.gd").new()
	GameState.current_enemy = player2
	
	print("Starting PvP battle with two loaded decks!")
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

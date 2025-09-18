extends Control

@onready var save_deck_button = $CenterContainer/VBoxContainer/SaveDeckButton
@onready var main_menu_button = $CenterContainer/VBoxContainer/MainMenu
@onready var level_label = $CenterContainer/VBoxContainer/Level

func _ready():
	# Connect the save button's signal
	save_deck_button.pressed.connect(Callable(self, "_on_save_deck_button_pressed"))
	main_menu_button.pressed.connect(Callable(self, "_on_main_menu_button_pressed"))
	level_label.text = "You beat %d levels!" % (GameState.current_level)
	
func _on_save_deck_button_pressed():
	var save_path = "user://saved_decks/"
	
	# Generate a unique filename using a timestamp
	var file_name = "deck_" + str(Time.get_unix_time_from_system()) + ".json"
	
	# Create the directory if it doesn't exist
	DirAccess.make_dir_recursive_absolute(save_path)
	
	var file = FileAccess.open(save_path + file_name, FileAccess.WRITE)
	
	if file:
		var deck_data_to_save: Array = []
		# Convert each card resource into its file path
		# Convert each card resource into its dictionary representation
		for card_data in GameState.player_deck:
			if card_data is Card:
				deck_data_to_save.append(card_data.to_dictionary())
		
		# Convert the array of dictionaries to a JSON string
		var json_string = JSON.stringify(deck_data_to_save, "\t")
		
		# Write the JSON string to the file
		file.store_string(json_string)
		file.close()
		
		print("Deck saved to: " + save_path + file_name)
		save_deck_button.text = "Deck Saved!"
	else:
		print("Error saving deck file.")

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

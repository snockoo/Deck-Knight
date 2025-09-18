extends Control

# Battle Button
@onready var pick1_button = $Pick1
@onready var pick2_button = $Pick2
@onready var pick3_button = $Pick3

@onready var choice1_portrait = $BorderChoice1/Choice1Portrait
@onready var choice1_border = $BorderChoice1
@onready var choice1_name_label = $Choice1NameLabel
@onready var choice1_desc = $Desc1

@onready var choice2_portrait = $BorderChoice2/Choice2Portrait
@onready var choice2_border = $BorderChoice2
@onready var choice2_name_label = $Choice2NameLabel
@onready var choice2_desc = $Desc2

@onready var choice3_portrait = $BorderChoice3/Choice3Portrait
@onready var choice3_border = $BorderChoice3
@onready var choice3_name_label = $Choice3NameLabel
@onready var choice3_desc = $Desc3


var enemy1
var enemy2
var enemy3
var random_enemies: Array = []
# Level 0 
@export var enemy_pool0: Array[Script]
# Level 1 2 3 Forest Area, 4 Forest Miniboss
var zone1: Array = [1,2,3]
@export var enemy_pool1: Array[Script]
@export var miniboss_pool0: Array[Script]
# Level 5 6 7 City Area, 8 City Miniboss
var zone2: Array = [5,6,7]
@export var enemy_pool2: Array[Script]
@export var miniboss_pool1: Array[Script]
# Level 9 10 11 Mountain Area, 12 Mountain Miniboss
var zone3: Array = [9,10,11]
@export var enemy_pool3: Array[Script]
@export var miniboss_pool2: Array[Script]
# Level 13 Final Boss
@export var final_boss: Array[Script]

@export var secret0: Array[Script]
@export var secret1: Array[Script]
@export var secret2: Array[Script]


@export var testpool: Array[Script]

func _ready() -> void:
	var pool_used = enemy_pool0
	if GameState.current_level == 0:
		pool_used = enemy_pool0
	if GameState.current_level in zone1:
		pool_used = enemy_pool1
	if GameState.current_level == 4:
		pool_used = miniboss_pool0
	if GameState.current_level in zone2:
		pool_used = enemy_pool2
	if GameState.current_level == 8:
		pool_used = miniboss_pool1
	if GameState.current_level in zone3:
		pool_used = enemy_pool3
	if GameState.current_level == 12:
		pool_used = miniboss_pool2
	if GameState.current_level >= 13:
		pool_used = final_boss
		
	#pool_used = testpool #DELETE THIS LATER
	
	for card_instance in GameState.player_deck:
		# Check if the card's name matches the secret card's name
		if card_instance.name == "Shard of Twilight" && GameState.current_level == 4:
			pool_used = secret0
		if card_instance.name == "Festering Bloom" && GameState.current_level == 8:
			pool_used = secret1
		if card_instance.name == "Ebon Ram" && GameState.current_level == 12:
			pool_used = secret2
	
	random_enemies = select_unique_enemies(3, pool_used)
	
	#Loads Enemy Data
	# Load and display the data for the first enemy
	if random_enemies.size() > 0:
		var enemy1 = random_enemies[0].new()
		choice1_portrait.texture = enemy1.portrait
		choice1_border.texture = enemy1.border
		choice1_name_label.text = enemy1.display_name
		choice1_desc.text = enemy1.desc
		pick1_button.pressed.connect(Callable(self, "_on_pick_button_pressed").bind(enemy1))
	
	# Load and display the data for the second enemy
	if random_enemies.size() > 1:
		var enemy2 = random_enemies[1].new()
		choice2_portrait.texture = enemy2.portrait
		choice2_border.texture = enemy2.border
		choice2_name_label.text = enemy2.display_name
		choice2_desc.text = enemy2.desc
		pick2_button.pressed.connect(Callable(self, "_on_pick_button_pressed").bind(enemy2))

	# Load and display the data for the third enemy
	if random_enemies.size() > 2:
		var enemy3 = random_enemies[2].new()
		choice3_portrait.texture = enemy3.portrait
		choice3_border.texture = enemy3.border
		choice3_name_label.text = enemy3.display_name
		choice3_desc.text = enemy3.desc
		pick3_button.pressed.connect(Callable(self, "_on_pick_button_pressed").bind(enemy3))
	
func _on_pick_button_pressed(enemy_instance):
	# Pass the enemy to the global GameState.
	GameState.current_enemy = enemy_instance
	# Now, change the scene to the main battle scene.
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func select_unique_enemies(count: int, pool: Array) -> Array:
	var selected = []
	pool.shuffle()
	
	for i in range(min(count, pool.size())):
		selected.append(pool[i])
		
	return selected

extends Node

# Reference the HBoxContainer from the scene tree
@onready var player_hand_container = $HUD/ScrollContainer2/PlayerHandContainer
# Reference the HBoxContainer from the scene tree
@onready var enemy_hand_container = $HUD/ScrollContainer/EnemyHandContainer
# Load the CardUI scene
var card_ui_scene = preload("res://card_scenes/CardUI.tscn")
# Preload the health bar scene so you can instantiate it
var health_bar_scene = preload("res://card_scenes/HealthBar.tscn")
# Preload floating text
var floating_text_scene = preload("res://card_scenes/floating_text.tscn")

var player_hand_uis: Array = []  # New: Array for CardUI instances
var enemy_deck_uis: Array = []    # New: Array for Enemy CardUI instances

# Health Bar Progress
@onready var enemy_health_bar_container = $HUD/TopBar/EnemyHealthBar # This would be a new container node
@onready var player_health_bar_container = $HUD/BottomBar/PlayerHealthBar # This would be another new container node

# Portraits and Names
@onready var enemy_portrait = $HUD/BorderEnemy/EnemyPortrait
@onready var enemy_name_label = $HUD/EnemyNameLabel
@onready var enemy_border = $HUD/BorderEnemy
@onready var player_portrait = $HUD/BorderPlayer/PlayerPortrait
@onready var player_name_label = $HUD/PlayerNameLabel
@onready var player_border = $HUD/BorderPlayer

#Finish Button
@onready var finish_button = $HUD/Finish

var player_health_bar
var enemy_health_bar

var enemy
var player
var player_hand: Array[Card] = []

var is_battle_over: bool = false

func _ready():
	# Put them into player hand
	player_hand = GameState.player_deck
	
	player = preload("res://data/chara/player.gd").new()
	enemy = GameState.current_enemy
	GameState.last_defeated_enemy_deck = enemy.deck
	
	# Resets Status
	_reset_all_status()
	
	# Displays the cards
	_display_player_hand()
	_display_enemy_hand()
	
	# Displays the Portrait and Names
	_update_player_ui()
	_update_enemy_ui()
	
	# Displays the health bar
	# Instantiate the player's health bar
	player_health_bar = health_bar_scene.instantiate()
	player_health_bar_container.add_child(player_health_bar)
	
	# Instantiate the enemy's health bar
	enemy_health_bar = health_bar_scene.instantiate()
	enemy_health_bar_container.add_child(enemy_health_bar)
	
	
	# Start auto battle
	battle_loop()
	

func battle_loop() -> void:
	_run_battle()

# Add a variable to track the current fatigue damage.
var fatigue_damage: float = 0.0
var battle_timer: SceneTreeTimer
var fatigue_timer: SceneTreeTimer
var is_fatigue_active = false
var tick_timer: SceneTreeTimer
var is_tick_active = false

func _run_battle() -> void:
	var all_card_uis: Array = []
	
	# Wrap CardUI nodes with their owner instead of Card resources
	for card_ui in player_hand_uis:
		all_card_uis.append({ "card_ui": card_ui, "owner": player })
	for card_ui in enemy_deck_uis:
		all_card_uis.append({ "card_ui": card_ui, "owner": enemy })

	# Floating Texts
	for card_ui_instance in player_hand_uis:
		card_ui_instance.card_used.connect(Callable(self, "_on_card_used"))
	for card_ui_instance in enemy_deck_uis:
		card_ui_instance.card_used.connect(Callable(self, "_on_card_used"))

	for entry in all_card_uis:
		print("- Owner:", entry["owner"], "Card:", entry["card_ui"].card_data.name)
		var card_ui_instance = entry["card_ui"]
		
		# Damage Signal
		card_ui_instance.card_data.damage_dealt.connect(
			Callable(self, "_on_card_damage_dealt")
		)
		
		# Connect the buff_requested signal
		card_ui_instance.card_data.buff_requested.connect(
			Callable(self, "_on_buff_requested")
		)
		
		# Connect the debuff_requested signal
		card_ui_instance.card_data.debuff_requested.connect(
			Callable(self, "_on_debuff_requested")
		)
		
		# Connect the recovery_requested signal
		card_ui_instance.card_data.recovery_requested.connect(
			Callable(self, "_on_recovery_requested")
		)
		
		# Connect the charge_requested signal
		card_ui_instance.card_data.charge_requested.connect(
			Callable(self, "_on_charge_requested")
		)
		
		# Connect the charge_requested signal
		card_ui_instance.card_data.slow_requested.connect(
			Callable(self, "_on_slow_requested")
		)
		
		# Connect the additive_requested signal
		card_ui_instance.card_data.additive_requested.connect(
			Callable(self, "_on_additive_requested")
		)
		
	#_update_hp_bar()
	#var startdelay = get_tree().create_timer(2.0)
	#await startdelay.timeout
	
	# Start the battle timer. This timer will trigger fatigue. Fatigue Timer
	battle_timer = get_tree().create_timer(30.0)
	# Main battle loop
	for entry in all_card_uis:
		_run_card_loop(entry)
		
	while enemy.is_alive() and player.is_alive():
		_update_hp_bar()
		
		if battle_timer.time_left <= 0.0 and not is_fatigue_active:
			is_fatigue_active = true
			fatigue_timer = get_tree().create_timer(0.5, true)
			fatigue_timer.connect("timeout", Callable(self, "_apply_fatigue_damage"))
		
		if not is_tick_active:
			is_tick_active = true
			tick_timer = get_tree().create_timer(1, true)
			tick_timer.connect("timeout", Callable(self, "_apply_tick"))
		
		await get_tree().process_frame
	
	player_health_bar.update_health(player.hp, player.max_hp)
	enemy_health_bar.update_health(enemy.hp, enemy.max_hp)
	player_health_bar.update_shield(player.shield, player.max_hp)
	enemy_health_bar.update_shield(enemy.shield, enemy.max_hp)
	player_health_bar.update_status(player.burn, player.poison, player.regen)
	enemy_health_bar.update_status(enemy.burn, enemy.poison, enemy.regen)
	is_battle_over = true

	# Increases player max hp every even rounds
	if player.is_alive():
		var bonus_rounds: Array = [0, 3, 7, 8, 11]
		if GameState.current_level in bonus_rounds:
			GameState.max_player_hp += 250
			show_floating_text("+ 250 Max Health", Color.GREEN, player_health_bar_container.global_position + Vector2(750, 65))
			player_health_bar.update_health(player.hp, GameState.max_player_hp)
	
	# Loop through all player cards and reset them
	for card_ui in player_hand_uis:
		if is_instance_valid(card_ui):
			card_ui.reset_cooldown()

	# Loop through all enemy cards and reset them
	for card_ui in enemy_deck_uis:
		if is_instance_valid(card_ui):
			card_ui.reset_cooldown()
	battle_timer.timeout.disconnect(Callable(self, "_on_battle_timer_timeout"))
	finish_button.pressed.connect(Callable(self, "_on_finish_button_pressed"))
	
func _update_hp_bar() -> void:
	player_health_bar.update_health(player.hp, player.max_hp)
	enemy_health_bar.update_health(enemy.hp, enemy.max_hp)
	player_health_bar.update_shield(player.shield, player.max_hp)
	enemy_health_bar.update_shield(enemy.shield, enemy.max_hp)
	player_health_bar.update_status(player.burn, player.poison, player.regen)
	enemy_health_bar.update_status(enemy.burn, enemy.poison, enemy.regen)

func _apply_fatigue_damage() -> void:
	if player.is_alive() and enemy.is_alive():
		fatigue_damage += 1.0
		player.hp -= max(fatigue_damage - player.shield, 0)
		player.shield = max(player.shield - fatigue_damage, 0)
		enemy.hp -= max(fatigue_damage - enemy.shield, 0)
		enemy.shield = max(enemy.shield - fatigue_damage, 0)
		show_floating_text("%d Fatigue Damage" % fatigue_damage, Color.SADDLE_BROWN, player_health_bar_container.global_position + Vector2(750, 65))
		show_floating_text("%d Fatigue Damage" % fatigue_damage, Color.SADDLE_BROWN, enemy_health_bar_container.global_position + Vector2(750, 65))
		is_fatigue_active = false

func _apply_tick() -> void:
	if player.is_alive() and enemy.is_alive():
		# Burn Damage
		if player.burn > 0:
			player.hp -= max(player.burn - player.shield, 0)
			player.shield = max(player.shield - player.burn, 0)
			show_floating_text("%d Burn Damage" % player.burn, Color.ORANGE, player_health_bar_container.global_position + Vector2(1220, 65))
			var burnreduction = floor(player.burn / 25)
			player.burn -= (1 + burnreduction)
		if enemy.burn > 0:
			enemy.hp -= max(enemy.burn - enemy.shield,0)
			enemy.shield = max(enemy.shield - enemy.burn, 0)
			show_floating_text("%d Burn Damage" % enemy.burn, Color.ORANGE, enemy_health_bar_container.global_position + Vector2(1220, 65))
			var burnreduction = floor(enemy.burn / 25)
			enemy.burn -= (1 + burnreduction)
		
		# Poison Damage
		if player.poison > 0:
			player.hp -= player.poison
			show_floating_text("%d Poison Damage" % player.poison, Color.DARK_GREEN, player_health_bar_container.global_position + Vector2(1100, 65))
		if enemy.poison > 0:
			enemy.hp -= enemy.poison
			show_floating_text("%d Poison Damage" % enemy.poison, Color.DARK_GREEN, enemy_health_bar_container.global_position + Vector2(1100, 65))
		
		# Regen Healing
		if player.regen > 0:
			if player.hp > 0:
				player.hp = min(player.hp + player.regen, player.max_hp)
				show_floating_text("%d Regen Heal" % player.regen, Color.LAWN_GREEN, player_health_bar_container.global_position + Vector2(350, 65))
		if enemy.regen > 0:
			if enemy.hp > 0:
				enemy.hp = min(enemy.hp + enemy.regen, enemy.max_hp)
				show_floating_text("%d Regen Heal" % enemy.regen, Color.LAWN_GREEN, enemy_health_bar_container.global_position + Vector2(350, 65))
		
		
		
		is_tick_active = false

func _reset_all_status() -> void:
	player.burn = 0
	player.poison = 0
	player.regen = 0
	enemy.burn = 0
	enemy.poison = 0
	enemy.regen = 0
	
# Each card handles its own cooldown cycle
func _run_card_loop(entry: Dictionary) -> void:
	var card_ui: Control = entry["card_ui"]
	var owner = entry["owner"]
	var target = enemy if owner == player else player

	while owner.is_alive() and target.is_alive():
		# The CardUI instance now handles its own visual cooldown and effect resolution.
		await card_ui.start_autobattle(owner, target)
		

func _update_player_ui():
	# Check if the enemy has a portrait texture
	if player.portrait:
		player_portrait.texture = player.portrait
		player_border.texture = player.border
	# Set the name label's text
	player_name_label.text = player.display_name
	
func _update_enemy_ui():
	# Check if the enemy has a portrait texture
	if enemy.portrait:
		enemy_portrait.texture = enemy.portrait
		enemy_border.texture = enemy.border
	# Set the name label's text
	enemy_name_label.text = enemy.display_name

func _display_player_hand():
	# Clear any existing cards
	for child in player_hand_container.get_children():
		child.queue_free()

	# Loop through the player's hand and create a UI instance for each card
	for card_data in player_hand:
		# Duplicate the card resource before instantiating the UI
		var card_data_copy = card_data.duplicate(true)
		
		var card_ui_instance = card_ui_scene.instantiate()
		# Set the cards data
		card_ui_instance.card_data = card_data_copy
		
		# Add the UI instance to the container
		player_hand_container.add_child(card_ui_instance)
		
		player_hand_uis.append(card_ui_instance)

	print("Player Cards displayed in UI.")

func _display_enemy_hand():
	# Clear any existing cards
	for child in enemy_hand_container.get_children():
		child.queue_free()

	# Loop through the player's hand and create a UI instance for each card
	for card_data in enemy.deck:
		var card_data_copy = card_data.duplicate(true)
		var card_ui_instance = card_ui_scene.instantiate()

		# Set the card data
		card_ui_instance.card_data = card_data_copy
		
		# Add the UI instance to the container
		enemy_hand_container.add_child(card_ui_instance)
		
		enemy_deck_uis.append(card_ui_instance)

	print("Enemy Cards displayed in UI.")

# Central Hub for Detecting Signals
func _on_card_damage_dealt(damage_amount, user, target) -> void:
	# Determine which team's cards to check for a combo effect
	var cards_to_check: Array = []
	if user == player:
		cards_to_check = player_hand_uis
	elif user == enemy:
		cards_to_check = enemy_deck_uis
		
	# Loop through the correct team's cards
	for card_ui in cards_to_check:
		var card_data = card_ui.card_data
		
		# Make sure this card is not the one that just dealt the damage.
		# The card_data here is not the user; the user is the player/enemy object.
		# A better check is to use a unique ID or a direct reference.
		# For simplicity, let's assume the cards are not the user objects themselves.
		
		# Now check for the "combo_damage" effect
		for effect_data in card_data.effects:
			if effect_data.type == "combo_damage":
				var combo_damage = effect_data.value
				if effect_data.buff_type == "damage":
					target.hp -= max(combo_damage - target.shield, 0)
					target.shield = max(target.shield - combo_damage, 0)
				if effect_data.buff_type == "shield":
					user.shield += combo_damage
				if effect_data.buff_type == "burn":
					target.burn += combo_damage
				if effect_data.buff_type == "lifesteal":
					target.hp -= max(combo_damage - target.shield, 0)
					target.shield = max(target.shield - combo_damage, 0)
					if user.hp > 0:
						user.hp = min(user.hp + combo_damage, user.max_hp)
						
					var regenreduction = ceil(combo_damage / 20)
					target.regen = max(target.regen - regenreduction, 0)
				if effect_data.buff_type == "maxhp":
					user.max_hp += combo_damage
				
				_on_card_used(user,target,card_ui)

# New function to handle buff requests
func _on_buff_requested(user, buff_type, buff_value, buffing_card, add_type):
	var cards_to_buff: Array = []
	
	if user == player:
		# Get the CardUI instances from the player's hand
		cards_to_buff = player_hand_uis
	elif user == enemy:
		# Get the CardUI instances from the enemy's hand
		cards_to_buff = enemy_deck_uis
	
	# First, filter the cards to only include those with the correct effect type
	var filtered_cards: Array = []
	for card_ui in cards_to_buff:
		var card_data = card_ui.card_data
		for effect_data in card_data.effects:
			# New check: Skip the card that is doing the buffing
			if card_data == buffing_card:
				continue
			# Check if the card has an effect that matches the buff type
			if effect_data.get("type") == buff_type:
				filtered_cards.append(card_ui)
				break # Move to the next card once a match is found
	
	# Check if there are any cards to buff
	if filtered_cards.size() == 0:
		print("❌ No cards with a '%s' effect to buff!" % buff_type)
		return
		
	# Randomly select a card to buff
	
	var random_card_ui = filtered_cards.pick_random()
	var card_data_to_buff = random_card_ui.card_data
	
	# Find the effect to buff
	if add_type == "single":
		for effect_data in card_data_to_buff.effects:
			if effect_data.get("type") == buff_type:
				effect_data["value"] += buff_value
				# Tell the CardUI to update its display
				random_card_ui.card_data.data_changed.emit()
				return
	if add_type == "multiple":
		for card_ui_instance in filtered_cards:
		# Access the card_data directly from the card_ui_instance
			for effect_data in card_ui_instance.card_data.effects:
				if effect_data.get("type") == buff_type:
					effect_data["value"] += buff_value
		# Tell the CardUI to update its display
					card_ui_instance.card_data.data_changed.emit()
	
# New function to handle buff requests
func _on_debuff_requested(user, buff_type, buff_value, buffing_card, add_type):
	var cards_to_debuff: Array = []
	
	if user == player:
		# Get the CardUI instances from the player's hand
		cards_to_debuff = enemy_deck_uis
	elif user == enemy:
		# Get the CardUI instances from the enemy's hand
		cards_to_debuff = player_hand_uis
	
	# First, filter the cards to only include those with the correct effect type
	var filtered_cards: Array = []
	for card_ui in cards_to_debuff:
		var card_data = card_ui.card_data
		for effect_data in card_data.effects:
			# New check: Skip the card that is doing the buffing
			if card_data == buffing_card:
				continue
			# Check if the card has an effect that matches the buff type
			if effect_data.get("type") == buff_type:
				filtered_cards.append(card_ui)
				break # Move to the next card once a match is found
	
	# Check if there are any cards to buff
	if filtered_cards.size() == 0:
		print("❌ No cards with a '%s' effect to debuff!" % buff_type)
		return
		
	# Randomly select a card to buff
	var random_card_ui = filtered_cards.pick_random()
	
	var card_data_to_buff = random_card_ui.card_data
	
	# Find the effect to buff
	if add_type == "single":
		for effect_data in card_data_to_buff.effects:
			if effect_data.get("type") == buff_type:
				effect_data["value"] = max(effect_data["value"] - buff_value, 0)
				# Tell the CardUI to update its display
				random_card_ui.card_data.data_changed.emit()
				return
	if add_type == "multiple":
		for card_ui_instance in filtered_cards:
		# Access the card_data directly from the card_ui_instance
			for effect_data in card_ui_instance.card_data.effects:
				if effect_data.get("type") == buff_type:
					effect_data["value"] = max(effect_data["value"] - buff_value, 0)
		# Tell the CardUI to update its display
					card_ui_instance.card_data.data_changed.emit()

func _on_charge_requested(user, buff_type, buff_value, buffing_card):
	var cards_to_buff: Array = []
	if user == player:
		# Get the CardUI instances from the player's hand
		cards_to_buff = player_hand_uis
	elif user == enemy:
		# Get the CardUI instances from the enemy's hand
		cards_to_buff = enemy_deck_uis
	
	# First, filter the cards to only include those with the correct effect type
	var filtered_cards: Array = []
	if buff_type == "any":
		for card_ui in cards_to_buff:
			filtered_cards.append(card_ui)
	else:
		for card_ui in cards_to_buff:
			var card_data = card_ui.card_data
			for tag_data in card_data.tags:
				# Check if the card has an effect that matches the buff type
				if tag_data == buff_type && card_data.cooldown_sec != 99999 && card_data.cooldown_sec != 0.1:
					filtered_cards.append(card_ui)
	
	# Check if there are any cards to buff
	if filtered_cards.size() == 0:
		print("❌ No cards with a '%s' effect to buff!" % buff_type)
		return
		
	# Randomly select a card to buff
	var random_card_ui = filtered_cards.pick_random()
	
	var card_data_to_buff = random_card_ui.card_data
	
	random_card_ui.reduce_cooldown(float(buff_value))
	
func _on_slow_requested(user, buff_type, buff_value, buffing_card):
	var cards_to_buff: Array = []
	if user == player:
		# Get the CardUI instances from the player's hand
		cards_to_buff = enemy_deck_uis
	elif user == enemy:
		# Get the CardUI instances from the enemy's hand
		cards_to_buff = player_hand_uis
	
	# First, filter the cards to only include those with the correct effect type
	var filtered_cards: Array = []
	if buff_type == "any":
		for card_ui in cards_to_buff:
			filtered_cards.append(card_ui)
	else:
		for card_ui in cards_to_buff:
			var card_data = card_ui.card_data
			for tag_data in card_data.tags:
				# Check if the card has an effect that matches the buff type
				if tag_data == buff_type && card_data.cooldown_sec != 99999 && card_data.cooldown_sec != 0.1:
					filtered_cards.append(card_ui)
	
	# Check if there are any cards to buff
	if filtered_cards.size() == 0:
		print("❌ No cards with a '%s' effect to slow!" % buff_type)
		return
		
	# Randomly select a card to buff
	var random_card_ui = filtered_cards.pick_random()
	
	var card_data_to_buff = random_card_ui.card_data
	
	random_card_ui.increase_cooldown(float(buff_value))
	

func _on_recovery_requested(user, buff_value, buffing_card):
	var cards_to_buff: Array = []

	if user == player:
		# Get the CardUI instances from the player's hand
		cards_to_buff = player_hand_uis
	elif user == enemy:
		# Get the CardUI instances from the enemy's hand
		cards_to_buff = enemy_deck_uis
	
	# First, filter the cards to only include those with the correct effect type
	var filtered_cards: Array = []
	for card_ui in cards_to_buff:
		var card_data = card_ui.card_data
		if card_data["cooldown_sec"] != 0.1 :
			for effect_data in card_data.effects:
				# New check: Skip the card that is doing the buffing
				if card_data == buffing_card:
					continue
				# Check if the card has an effect that matches the buff type
				if effect_data.has("ammo"):
					if effect_data.get("ammo") != -1:
						print(card_data["name"])
						filtered_cards.append(card_ui)
						break # Move to the next card once a match is found
		
	if filtered_cards.size() == 0:
		return
		
	# Check if the buffing card is an "all-cards" recovery card
	var is_all_recovery = false
	for effect_data in buffing_card.effects:
		if effect_data.get("type") == "ammo_recovery" && effect_data.get("add_type") == "all":
			is_all_recovery = true
			break
			
	if is_all_recovery:
		# Buff all filtered cards with ammo
		for card_ui_instance in filtered_cards:
			for effect_data in card_ui_instance.card_data.effects:
				if effect_data.has("ammo"):
					if effect_data.get("ammo") != -1:
						effect_data["ammo"] += buff_value
			card_ui_instance.card_data.data_changed.emit()
	else:
		# Randomly select a card to buff
		var random_card_ui = filtered_cards.pick_random()
		var card_data_to_buff = random_card_ui.card_data
		
		for effect_data in card_data_to_buff.effects:
			if effect_data.has("ammo"):
				if effect_data.get("ammo") != -1:
					effect_data["ammo"] += buff_value
		random_card_ui.card_data.data_changed.emit()
	

func _on_additive_requested(user, buff_type, effect_value, tags, add_type, card):
	var cards_to_buff: Array = []
	var target
	
	if user == player:
		# Get the CardUI instances from the player's hand
		target = enemy
		cards_to_buff = player_hand_uis
	elif user == enemy:
		# Get the CardUI instances from the enemy's hand
		cards_to_buff = enemy_deck_uis
		target = player
	
	# First, filter the cards to only include those with the correct effect type
	var filtered_cards: Array = []
	for card_ui in cards_to_buff:
		var card_data = card_ui.card_data
		for tag_data in card_data.tags:
			# Check if the card has an effect that matches the buff type
			if tag_data == tags:
				filtered_cards.append(card_ui)
	
	# Check if there are any cards in the tags
	if filtered_cards.size() == 0:
		return
		
	var final_value
	# If the add type is single do it only once
	if add_type == "single":
		final_value = effect_value
	else:
		final_value = effect_value * filtered_cards.size()
	
	if buff_type == "damage":
		target.hp -= max(final_value - target.shield, 0)
		target.shield = max(target.shield - final_value, 0)
		_on_card_damage_dealt(final_value, user, target)
	if buff_type == "heal":
		if user.hp > 0:
			user.hp = min(user.hp + final_value, user.max_hp)
			var poisonreduction = ceil(final_value / 20)
			user.poison = max(user.poison - poisonreduction, 0)
	if buff_type == "lifesteal":
		target.hp -= max(final_value - target.shield, 0)
		target.shield = max(target.shield - final_value, 0)
		_on_card_damage_dealt(final_value, user, target)
		if user.hp > 0:
			user.hp = min(user.hp + final_value, user.max_hp)
		var regenreduction = ceil(final_value / 20)
		target.regen = max(target.regen - regenreduction, 0)
	if buff_type == "shield":
		user.shield += final_value
	if buff_type == "burn":
		target.burn += final_value
	if buff_type == "regen":
		user.regen += final_value
	if buff_type == "poison":
		target.poison += final_value
		

func _on_card_used(user, target, card_ui_instance):
	# This is the new function that handles the card being played
	# Check if the card is usable before doing anything else
	if not card_ui_instance.is_usable():
		return
		
	# Get the position of the card UI instance
	var card_ui_position = card_ui_instance.global_position
	
	# Get the damage value from the card's data
	var text = ""
	for effect in card_ui_instance.card_data.effects:
		var timer = get_tree().create_timer(0.3)
		await timer.timeout
		if effect.type == "damage":
			text = "Dealt %d damage" % effect.value
			show_floating_text(str(text), Color.RED, card_ui_position)
		if effect.type == "heal":
			text = "Healed %d damage" % effect.value
			show_floating_text(str(text), Color.GREEN_YELLOW, card_ui_position)
		if effect.type == "lifesteal":
			text = "Dealt and healed %d damage" % effect.value
			show_floating_text(str(text), Color.MEDIUM_PURPLE, card_ui_position)
		if effect.type == "combo_damage":
			text = "%d Combo" % effect.value
			show_floating_text(str(text), Color.INDIAN_RED, card_ui_position)
		if effect.type == "buff":
			text = "Buffed %s by %d" % [effect.buff_type, effect.value]
			show_floating_text(str(text), Color.LIGHT_YELLOW, card_ui_position)
		if effect.type == "shield":
			text = "Shielded %d" % effect.value
			show_floating_text(str(text), Color.YELLOW, card_ui_position)
		if effect.type == "debuff":
			text = "Debuffed %s by %d" % [effect.buff_type, effect.value]
			show_floating_text(str(text), Color.REBECCA_PURPLE, card_ui_position)
		if effect.type == "burn":
			text = "Burned %d" % effect.value
			show_floating_text(str(text), Color.ORANGE, card_ui_position)
		if effect.type == "regen":
			text = "Regenerated %d" % effect.value
			show_floating_text(str(text), Color.LAWN_GREEN, card_ui_position)
		if effect.type == "poison":
			text = "Poisoned %d" % effect.value
			show_floating_text(str(text), Color.DARK_GREEN, card_ui_position)
		if effect.type == "charge":
			text = "Charged %s card by %d" % [effect.buff_type, effect.value]
			show_floating_text(str(text), Color.SKY_BLUE, card_ui_position)
		if effect.type == "ammo_recovery":
			text = "Recovered %d use" % effect.value
			show_floating_text(str(text), Color.ROSY_BROWN, card_ui_position)
		if effect.type == "additive":
			text = "Applied %s for every %s card" % [effect.buff_type, effect.tags]
			show_floating_text(str(text), Color.DARK_GOLDENROD, card_ui_position)
		if effect.type == "maxhp":
			text = "Increased Max HP by %d" % effect.value
			show_floating_text(str(text), Color.SEA_GREEN, card_ui_position)
	

# Show the floating text at the card's position
func show_floating_text(text_content: String, text_color: Color, position: Vector2):
	var floating_text_instance = floating_text_scene.instantiate()
	floating_text_instance.set_text_and_color(text_content, text_color)
	floating_text_instance.position = position
	add_child(floating_text_instance) # Add it to the scene tree

func _on_finish_button_pressed():
	if GameState.pvpmode:
		get_tree().change_scene_to_file("res://scenes/pvpmenu.tscn")
		GameState.pvpmode = false
		GameState.player1name = "Player"
		GameState.player2name = "Player2"
	else:
		if player.is_alive():
			GameState.player_deck = player_hand
			var hand_rounds: Array = [0, 3, 7, 8, 10, 11]
			if GameState.current_level in hand_rounds:
				GameState.deck_limit += 1
			GameState.current_level += 1
			
			get_tree().change_scene_to_file("res://scenes/reward.tscn")
		else:
			GameState.lives -= 1
			get_tree().change_scene_to_file("res://scenes/deckbuilding.tscn")

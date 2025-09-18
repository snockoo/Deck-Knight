# res://scripts/ui/CardUI.gd
extends Control

@export var card_data: Card
@onready var cooldown_bar = $CooldownBar
@onready var cooldown_label = $CooldownBar/Cooldown
@onready var tagsbox = $Panel/LabelTags
@onready var card_detail = $CardDetails
var main_game
var is_active: bool = false
var timer: SceneTreeTimer
var queued_reduction: float = 0.0

# Signals for deckbuilding
signal clicked(card_data)
signal removed_from_deck(card_data) # New signal for removing the card
signal card_used(user, target, card_ui_instance) # For position
@export var is_removable: bool = false # Use this to distinguish cards in the deck

# Original Stats
var original_name
var original_desc
var original_cost
var original_cooldown
var original_tags

func _ready():
	main_game = get_tree().get_first_node_in_group("main_game")
	
	original_name = card_data.name
		
	original_desc = card_data.get_dynamic_description()
	
	original_cost = "Cost: %d" % card_data.cost
	
	original_cooldown = "%.1f" % card_data.cooldown_sec
	if card_data.cooldown_sec == 99999 || card_data.cooldown_sec == 0.1:
		original_cooldown = "No Cooldown"
	
	original_tags = ""
	# Add all tags to the tagsbox
	if not card_data.tags.is_empty():
		# This joins the tags with ", " and sets the label's text
		original_tags = ", ".join(card_data.tags)
		
	$CardDetails/DetailName.text = original_name
	$CardDetails/DetailDesc.text = original_desc
	$CardDetails/DetailTags.text = original_tags
	$CardDetails/DetailCost.text = original_cost
	
	card_data.data_changed.connect(Callable(self, "_update_ui"))
	_update_ui()
	
	#card_detail.hide()
	$Panel/Button.pressed.connect(Callable(self, "_on_button_pressed"))
	$Panel/Button.mouse_entered.connect(Callable(self, "_on_button_mouse_entered"))
	$Panel/Button.mouse_exited.connect(Callable(self, "_on_button_mouse_exited"))
	
func _on_button_mouse_entered():
	card_detail.show()
		

func _on_button_mouse_exited():
	card_detail.hide()


func _on_button_pressed():
	if is_removable:
		# If the card is in the deck, emit the removed signal
		removed_from_deck.emit(card_data)
	else:
		# If the card is in the binder, emit the clicked signal
		clicked.emit(card_data)
	
			
# A new function to handle all UI updates.
func _update_ui():
	if card_data:
		$Panel/LabelName.text = card_data.name
		
		# Use the dynamic description function instead of the static property.
		$Panel/LabelDesc.text = card_data.get_dynamic_description()
		
		$Panel/LabelCost.text = "Cost: %d" % card_data.cost
		
		cooldown_label.text = "%.1f" % card_data.cooldown_sec
		if card_data.cooldown_sec == 99999 || card_data.cooldown_sec == 0.1:
			cooldown_label.text = "No Cooldown"
		
		# Add all tags to the tagsbox
		if not card_data.tags.is_empty():
			# This joins the tags with ", " and sets the label's text
			tagsbox.text = ", ".join(card_data.tags)
			tagsbox.show()
		else:
			tagsbox.hide()

# Called when this card is played/placed
func play(user, target):
	start_autobattle(user, target)

func start_autobattle(user, target):
	# New: Check if the battle is already over
	if main_game and main_game.is_battle_over:
		return
	# Wait according to card cooldown
	# Set the initial state of the cooldown bar.
	cooldown_bar.max_value = card_data.cooldown_sec
	cooldown_bar.value = 0
	
	timer = get_tree().create_timer(card_data.cooldown_sec - queued_reduction)
	queued_reduction = 0.0
	timer.timeout.connect(Callable(self, "resolve_effect").bind(user,target))
	
	# This loop visually updates the cooldown bar.
	while timer.time_left > 0:
		# Calculate the elapsed time since the timer started
		var elapsed_time = card_data.cooldown_sec - timer.time_left
		cooldown_bar.value = elapsed_time
		cooldown_label.text = "%.1f" % timer.time_left
		if card_data.cooldown_sec == 99999 || card_data.cooldown_sec == 0.1:
			cooldown_label.text = "No Cooldown"
			cooldown_bar.value = 0
		await get_tree().process_frame
	
	cooldown_bar.value = 0
	

func resolve_effect(user, target):
	card_used.emit(user,target,self)
	card_data.apply_effect(user, target)

func reduce_cooldown(amount):
	if timer.time_left == 0:
		queued_reduction += amount
	else:
		if amount - timer.time_left > 0:
			queued_reduction += amount - timer.time_left
		
		timer.time_left -= float(amount)

func increase_cooldown(amount):
	if timer.time_left == 0:
		queued_reduction -= amount
	else:	
		timer.time_left += float(amount)

func reset_cooldown():
	# Safely check for and disconnect the timer's signal
	if timer and is_instance_valid(timer):
		timer.timeout.disconnect(Callable(self, "resolve_effect"))
	# Reset the timer variable
	timer.time_left = 0.0
	
	# Reset the cooldown bar visually
	# cooldown_bar.value = 0

func is_usable() -> bool:
	# Check the ammo for each effect on the card
	for effect_data in card_data.effects:
		var ammo = effect_data.get("ammo", -1)
		if ammo == 0:
			# If any effect has 0 ammo, the card is not usable
			return false
	
	# You can also add other checks here, like for cooldowns
	# if cooldown_timer and cooldown_timer.time_left > 0:
	#     return false
	
	return true

extends ProgressBar

@onready var health_label = $Label
@onready var shield_label = $Shield
@onready var shield_bar = $ShieldBar

@onready var burn_label = $Burn
@onready var poison_label = $Poison
@onready var regen_label = $Regen

func _ready():
	# Hide the built-in percentage text.
	show_percentage = false

func update_health(current_hp, max_hp):
	value = current_hp
	max_value = max_hp
	health_label.text = str(int(current_hp)) + " / " + str(int(max_hp))

func update_shield(shield, max_hp):
	if(shield > max_hp):
		shield_bar.max_value = shield
	else:
		shield_bar.max_value = max_hp
	shield_bar.value = shield
	
	if (shield_label.text == "0"):
		shield_label.hide()
		shield_label.text = str(int(shield))
	else:
		shield_label.show()
		shield_label.text = str(int(shield))
		
func update_status(burn, poison, regen):
	# Burn
	if (burn_label.text == "0"):
		burn_label.hide()
		burn_label.text = str(int(burn))
	else:
		burn_label.show()
		burn_label.text = str(int(burn))
	# Poison
	if (poison_label.text == "0"):
		poison_label.hide()
		poison_label.text = str(int(poison))
	else:
		poison_label.show()
		poison_label.text = str(int(poison))
	# Regen
	if (regen_label.text == "0"):
		regen_label.hide()
		regen_label.text = str(int(regen))
	else:
		regen_label.show()
		regen_label.text = str(int(regen))

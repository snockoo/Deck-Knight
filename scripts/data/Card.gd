# res://scripts/data/Card.gd
@tool
class_name Card
extends Resource

# This signal will be emitted when the card's data changes.
signal data_changed
# Signal when a card deals damage
signal damage_dealt(damage_amount, user, target)
# Signal when a card wants to buff
signal buff_requested(user, buff_type, buff_value, card, add_type)
# Signal when a card wants to debuff
signal debuff_requested(user, buff_type, buff_value, card, add_type)
# Signal when a card wants to charge
signal charge_requested(user, buff_type, buff_value, card)
# Signal when a card wants to slow
signal slow_requested(user, buff_type, buff_value, card)
# Signal when a card wants to recover ammo
signal recovery_requested(user, buff_value, card)
# Signal when a card wants to do an additive effect
signal additive_requested(user, buff_type, buff_value, tags, add_type, card)

# --- Core info shown in the Inspector ---
@export var id: StringName = &"strike"          # unique stable identifier
@export var name: String = "Strike"             # display name
@export var description: String = "Deal 6 damage."
@export var cost: int = 1

# Cooldown/autobattler tempo (how often it "fires")
@export var cooldown_sec: float = 2.0

@export var effects: Array = []

# Optional: tags for synergies/search later
@export var tags: Array[String] = []

# Original copy's resource path
var original_resource_path: String = ""

func get_dynamic_description() -> String:
	var desc = ""
	for effect_data in effects:
		var effect_type = effect_data.get("type", "")
		var effect_value = effect_data.get("value", 0)
		var scaling = effect_data.get("scaling", 0)
		var buff_type = effect_data.get("buff_type", "")
		var ammo = effect_data.get("ammo", -1)
		var tags_type = effect_data.get("tags", "")
		var add_type = effect_data.get("add_type", "")
		
		if desc.length() > 0:
			desc += "\n" # Add a new line if there are multiple effects.

		match effect_type:
			"damage":
				desc += "Deal %d damage." % effect_value
				if scaling > 0:
					desc += " Damage scales by %d each use." % scaling
			"heal":
				desc += "Heal %d health." % effect_value
				if scaling > 0:
					desc += " Heal scales by %d each use." % scaling
			"lifesteal":
				desc += "Lifesteal for %d." % effect_value
				if scaling > 0:
					desc += " Lifesteal scales by %d each use." % scaling
			"combo_damage":
				desc += "Whenever you deal damage, also apply %d %s." % [effect_value, buff_type]
				if scaling > 0:
					desc += " Combo scales by %d each use." % scaling
			"buff":
				if add_type == "single":
					desc += "Increases another card's %s by %d." % [buff_type, effect_value]
				if add_type == "multiple":
					desc += "Increases all card's %s by %d." % [buff_type, effect_value]
				if scaling > 0:
					desc += " Buff scales by %d each use." % scaling
			"shield":
				desc += "Shield %d." % effect_value
				if scaling > 0:
					desc += " Shield scales by %d each use." % scaling
			"charge":
				desc += "Charge %s card by %d." % [buff_type, effect_value]
				if scaling > 0:
					desc += " Charge scales by %d each use." % scaling
			"slow":
				desc += "Slow %s card by %d." % [buff_type, effect_value]
			"debuff":
				if add_type == "single":
					desc += "Decreases another card's %s by %d." % [buff_type, effect_value]
				if add_type == "multiple":
					desc += "Decreases all card's %s by %d." % [buff_type, effect_value]
				if scaling > 0:
					desc += " Debuff scales by %d each use." % scaling
			"burn":
				desc += "Applies %d burn." % effect_value
				if scaling > 0:
					desc += " Burn scales by %d each use." % scaling
			"regen":
				desc += "Applies %d regen." % effect_value
				if scaling > 0:
					desc += " Regen scales by %d each use." % scaling
			"poison":
				desc += "Applies %d poison." % effect_value
				if scaling > 0:
					desc += " Poison scales by %d each use." % scaling
			"ammo_recovery":
				if add_type == "all":
					desc += "Recovers %d uses to all cards" % effect_value
				else:
					desc += "Recovers %d uses to another card." % effect_value
			"additive":
				if add_type == "single":
					desc += "Apply %d %s if you have a %s card." % [effect_value,buff_type, tags_type]
				if add_type == "multiple":
					desc += "Apply %d %s for every other %s card." % [effect_value,buff_type, tags_type]
			"maxhp":
				desc += "Increases Max HP by %d." % effect_value
				if scaling > 0:
					desc += " Max HP scales by %d each use." % scaling
		
		if cooldown_sec == 0.1:
			#desc = ""
			desc += " Used at the start of battle once."
		else:
			if ammo >= 0:
				desc += " Uses: %d." % [ammo]
		
	return desc
# ---- (Optional) Helper for applying the effect later ----
# We'll call this from a Battle/Board manager and pass targets.
func apply_effect(user: Node, target: Node) -> void:
	if target == null:
		print("No targets")
		return
		
	for effect_data in effects:
		var effect_type = effect_data.get("type", "")
		var effect_value = effect_data.get("value", 0)
		var scaling_per_use = effect_data.get("scaling", 0)
		var buff_type = effect_data.get("buff_type", "")
		var ammo = effect_data.get("ammo", -1)
		var tags_type = effect_data.get("tags", "")
		var add_type = effect_data.get("add_type", "")
		
		if ammo != 0:
			match effect_type:
				"damage":
					#Effects._apply_damage(user,target,effect_value)
					target.hp -= max(effect_value - target.shield, 0)
					target.shield = max(target.shield - effect_value, 0)
					
					# Emit the signal after dealing damage.
					damage_dealt.emit(effect_value, user, target)

					# Apply scaling if it exists
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						print("⬆️ Card damage increased to %d." % effect_data["value"])
						data_changed.emit() # Emit the signal after the value changes.

				"heal":
					if user.hp > 0:
						user.hp = min(user.hp + effect_value, user.max_hp)
						var poisonreduction = ceil(effect_value / 20)
						user.poison = max(user.poison - poisonreduction, 0)
					
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						print("⬆️ Card heal increased to %d." % effect_data["value"])
						data_changed.emit() # Emit the signal after the value changes.
					
				"lifesteal":
					target.hp -= max(effect_value - target.shield, 0)
					target.shield = max(target.shield - effect_value, 0)
					if user.hp > 0:
						user.hp = min(user.hp + effect_value, user.max_hp)
						
					var regenreduction = ceil(effect_value / 20)
					target.regen = max(target.regen - regenreduction, 0)
						
					# Emit the signal after dealing damage.
					damage_dealt.emit(effect_value, user, target)
					
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						print("⬆️ Card heal increased to %d." % effect_data["value"])
						data_changed.emit() # Emit the signal after the value changes.
					
				"buff":
					# Pass `self` to the signal so the receiver knows which card is buffing
					buff_requested.emit(user, buff_type, effect_value, self, add_type)

					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						data_changed.emit() # Emit the signal after the value changes.
				"shield":
					user.shield += effect_value
					
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						data_changed.emit() # Emit the signal after the value changes.
				"charge":
					# Pass `self` to the signal so the receiver knows which card is buffing
					charge_requested.emit(user, buff_type, effect_value, self)
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						data_changed.emit() # Emit the signal after the value changes.
				"slow":
					# Pass `self` to the signal so the receiver knows which card is buffing
					slow_requested.emit(user, buff_type, effect_value, self)
				"debuff":
					# Pass `self` to the signal so the receiver knows which card is buffing
					debuff_requested.emit(user, buff_type, effect_value, self, add_type)
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						data_changed.emit() # Emit the signal after the value changes.
				"burn":
					target.burn += effect_value
					# Apply scaling if it exists
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						data_changed.emit() # Emit the signal after the value changes.
				"regen":
					user.regen += effect_value
					# Apply scaling if it exists
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						data_changed.emit() # Emit the signal after the value changes.
				"poison":
					target.poison += effect_value
					# Apply scaling if it exists
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						data_changed.emit() # Emit the signal after the value changes.
				"ammo_recovery":
					recovery_requested.emit(user, effect_value, self)
				"additive":
					additive_requested.emit(user, buff_type, effect_value, tags_type, add_type, self)
				"maxhp":
					user.max_hp += effect_value
					if scaling_per_use > 0:
						effect_data["value"] += scaling_per_use
						data_changed.emit() # Emit the signal after the value changes.
		if ammo != -1:
			if effect_data["ammo"] != 0:
				effect_data["ammo"] -= 1
				data_changed.emit()
		else:
			effect_data["ammo"] = -1

func to_dictionary() -> Dictionary:
	var card_dict = {
		"resource_path": self.original_resource_path, # Keep a reference to the base card
		"effects": self.effects, # This array of dictionaries is already savable!
	}
	return card_dict

extends Node

func _testing_effect() -> void:
	print("TEST TEST")

func _apply_damage(user, target, effect_value) -> void:
	target.hp -= max(effect_value - target.shield, 0)
	target.shield = max(target.shield - effect_value, 0)
	
func _apply_heal(user, target, effect_value) -> void:
	if user.hp > 0:
		user.hp = min(user.hp + effect_value, user.max_hp)
		var poisonreduction = ceil(effect_value / 20)
		user.poison = max(user.poison - poisonreduction, 0)

func _apply_lifesteal(user, target, effect_value) -> void:
	target.hp -= max(effect_value - target.shield, 0)
	target.shield = max(target.shield - effect_value, 0)
	if user.hp > 0:
		user.hp = min(user.hp + effect_value, user.max_hp)
		
	var regenreduction = ceil(effect_value / 20)
	target.regen = max(target.regen - regenreduction, 0)

func _apply_shield(user, target, effect_value) -> void:
	user.shield += effect_value

func _apply_burn(user, target, effect_value) -> void:
	target.burn += effect_value
	
func _apply_poison(user, target, effect_value) -> void:
	target.poison += effect_value

func _apply_regen(user, target, effect_value) -> void:
	user.regen += effect_value
	
func _apply_maxhp(user, target, effect_value) -> void:
	user.max_hp += effect_value

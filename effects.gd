extends Node

func _testing_effect() -> void:
	print("TEST TEST")

func _apply_damage(user, target, effect_value) -> void:
	target.hp -= max(effect_value - target.shield, 0)
	target.shield = max(target.shield - effect_value, 0)
	

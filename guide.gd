extends Control

@onready var back_button = $Back

func _ready():
	back_button.pressed.connect(Callable(self, "_on_back_pressed"))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	

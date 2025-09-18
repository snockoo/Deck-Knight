# res://FloatingText.gd
extends Label

var speed: float = 70.0 # Speed at which the text moves up
var lifetime: float = 1 # How long the text stays on screen

func _ready():
	# Use a Tween to animate the position and alpha
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	
	# Move the label up
	tween.tween_property(self, "position", position - Vector2(0, 40), lifetime)
	
	# Fade out the label by animating its modulate (color)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), lifetime)
	
	# When the tween finishes, free the node from memory
	tween.tween_callback(self.queue_free)

func set_text_and_color(text_content: String, text_color: Color):
	self.text = text_content
	self.modulate = text_color

extends RichTextLabel

class_name AnimatedDamageTakenLabel

func _ready() -> void:
	visible = false

func _bounce_once() -> void:
	visible = true
	
	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.3)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
	
	await get_tree().create_timer(0.6).timeout
	visible = false

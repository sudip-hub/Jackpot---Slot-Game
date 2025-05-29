extends Control

func _ready() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property($Info, "scale", Vector2(1, 1), 0.3)
	
	var close_btn = custom_button.new()
	close_btn.initialize($Close, $Close/TextureRect)
	close_btn.connect("btn_pressed", _on_close_btn_pressed)
	
func _on_close_btn_pressed() -> void:
	queue_free()

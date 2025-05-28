extends Node

class_name custom_button

signal btn_pressed

var btn
var anim_node
var is_mouse_entered : bool = true
var is_mouse_exited : bool = false
var anim_speed = 0.08

func initialize(p_btn_node : Button, p_anim_node) -> void:
	btn = p_btn_node
	anim_node = p_anim_node
	btn.connect("pressed", on_button_pressed)
	btn.connect("button_down", on_button_down)
	btn.connect("mouse_entered", on_mouse_entered)
	btn.connect("mouse_exited", on_mouse_exited)

func on_mouse_entered() -> void:
	print("Is mouse Enterd : ", anim_node)
	is_mouse_entered = true
	is_mouse_exited = false
	
func on_mouse_exited() -> void:
	is_mouse_exited = true
	is_mouse_entered = false
	on_button_pressed()
	
func on_button_down() -> void:
	var btn_press_tween = create_tween().bind_node(anim_node)
	btn_press_tween.set_ease(Tween.EASE_OUT)
	btn_press_tween.tween_property(anim_node, "scale", Vector2(0.9, 0.9), anim_speed)
	
func on_button_pressed() -> void:
	var btn_press_tween = create_tween().bind_node(anim_node)
	btn_press_tween.set_ease(Tween.EASE_IN)
	await btn_press_tween.tween_property(anim_node, "scale", Vector2(1, 1), anim_speed - 0.02).finished
	if is_mouse_entered:
		btn_pressed.emit()

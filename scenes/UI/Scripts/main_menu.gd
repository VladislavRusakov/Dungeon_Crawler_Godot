extends Control

@onready var main_buttons = $CanvasLayer/MainButtons
@onready var options_panel = $CanvasLayer/OptionsPanel


func _ready():
	main_buttons.visible = true
	options_panel.visible = false


func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")


func _on_load_game_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	main_buttons.visible = false
	options_panel.visible = true


func _on_exit_pressed():
	get_tree().quit()


func _on_back_options_pressed():
	_ready()

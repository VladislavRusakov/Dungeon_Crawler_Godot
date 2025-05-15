extends Control

@onready var main_buttons = $CanvasLayer/MainButtons
@onready var options_panel = $CanvasLayer/OptionsPanel


func _ready():
	main_buttons.visible = false
	options_panel.visible = false

func pause_menu_called():
	options_panel.visible = false
	main_buttons.visible = true

func pause_menu_closed():
	_ready()

func autosave():
	pass

func _on_save_game_pressed():
	pass

func _on_load_game_pressed():
	pass # Replace with function body.

func _on_options_pressed():
	main_buttons.visible = false
	options_panel.visible = true

func _on_main_menu_pressed():
	autosave()
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	pause_menu_called()

extends Node3D

var is_open := false

@onready var animation = $HatchAnimation
@onready var sfx_hatch_open = $sfx_hatch_open


func toggle():
	if is_open:
		close_gate()
	else:
		open_gate()

func open_gate():
	if is_open:
		return
	is_open = true

	print("Hatch opening!")

	if animation.has_animation("hatch_open"):
		animation.play("hatch_open")
	else:
		print("Missing animation: ")
		
	if sfx_hatch_open.stream:
		sfx_hatch_open.play()

func close_gate():
	if !is_open:
		return
	is_open = false
	if animation.has_animation("hatch_open"):
		animation.play_backwards("hatch_open")
	
	if sfx_hatch_open.stream:
		sfx_hatch_open.play()

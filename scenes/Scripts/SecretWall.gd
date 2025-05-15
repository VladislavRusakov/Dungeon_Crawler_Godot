extends Node3D

var is_open := false

@onready var animation = $DoorSlideAnimation
@onready var sfx_wall_open = $sfx_wall_open


func toggle():
	if is_open:
		close_gate()
	else:
		open_gate()

func open_gate():
	if is_open:
		return
	is_open = true
	animation.play("slide_up")
	
	if sfx_wall_open.stream:
		sfx_wall_open.play()

func close_gate():
	if !is_open:
		return
	is_open = false
	animation.play_backwards("slide_up")
	
	if sfx_wall_open.stream:
		sfx_wall_open.play()

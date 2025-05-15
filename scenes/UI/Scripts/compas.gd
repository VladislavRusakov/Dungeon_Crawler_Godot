extends Node3D

@onready var compass_disc = $CompasBody/CompassDisc
@onready var player = get_parent()  # Adjust if attached differently
@onready var animation = $animation

@onready var sfx_compass_out = $sfx_compass_out
@onready var sfx_compass_back = $sfx_compass_back


var is_out:= false

func _process(_delta):
	if not player:
		return

	# Get the player's forward direction (local -Z axis)
	var forward = -player.global_transform.basis.z
	var yaw = atan2(forward.x, forward.z)

	# Rotate the compass disc so "N" points world north
	compass_disc.rotation.y = -yaw

func compass_draw():
	if not is_out:
		animation.play("draw")
		sfx_compass_out.play()
	else:
		animation.play_backwards("draw")
		sfx_compass_back.play()
	is_out = !is_out

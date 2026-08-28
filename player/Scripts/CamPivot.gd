extends Node3D

@onready var camera_pivot = $"."
@onready var camera = $Camera

var is_looking := false
var mouse_sensitivity := 0.005
var yaw := 0.0
var pitch := 0.0

# Limits in radians. YAW is horizontal, PITCH is vertical
const MAX_YAW := deg_to_rad(55)
const MAX_PITCH := deg_to_rad(90)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseMotion and is_looking:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity

		# Clamp angles to your limits
		yaw = clamp(yaw, -MAX_YAW, MAX_YAW)
		pitch = clamp(pitch, -MAX_PITCH, MAX_PITCH)

		camera_pivot.rotation.y = yaw
		camera.rotation.x = pitch

func _process(_delta):
	if Input.is_action_pressed("unlock_camera"):
		if not is_looking:
			is_looking = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		if is_looking:
			is_looking = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_snap_camera_back()

func _snap_camera_back():
	yaw = 0
	pitch = 0
	camera_pivot.rotation.y = 0
	camera.rotation.x = 0

extends StaticBody3D

@onready var target = $"../../LevelBlock28/Hatch1"
@onready var sfx_button_push = $sfx_button_push
@onready var parent_block = get_parent()  # Assumes button is child of a LevelBlock

@export var cooldown_duration := 1.5
@export var face_during_cooldown := 8  # Change this to whatever texture index you want
var can_press := true

func on_interact():
	if not can_press:
		print("Button is cooling down.")
		return

	var player = get_tree().get_first_node_in_group("player")
	var distance = global_transform.origin.distance_to(player.global_transform.origin)
	if distance > 1.0:
		return

	var facing = -player.transform.basis.z.normalized()
	var to_me = (global_transform.origin - player.global_transform.origin).normalized()
	var angle = facing.angle_to(to_me)
	if angle > deg_to_rad(45):
		return
	
	if target:
		target.toggle()
		sfx_button_push.play()
	
	print("Button Pressed!")

	# -- Begin Cooldown --
	can_press = false
	var original_face: int = parent_block.south_face
	parent_block.south_face = face_during_cooldown

	await get_tree().create_timer(cooldown_duration).timeout

	parent_block.south_face = original_face
	can_press = true


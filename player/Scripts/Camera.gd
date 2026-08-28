extends Camera3D

var mouse = Vector2()

func _input(event):
	if event is InputEventMouse:
		mouse = event.position
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
			get_selection()

func get_selection():
	var worldspace = get_world_3d().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 1000)

	var params = PhysicsRayQueryParameters3D.create(start, end)
	# params.collision_mask = 1 << 2  # Only check layer 2 (interactables)

	var result = worldspace.intersect_ray(params)
	if result:
		if result.collider.has_method("on_interact"):
			result.collider.on_interact()

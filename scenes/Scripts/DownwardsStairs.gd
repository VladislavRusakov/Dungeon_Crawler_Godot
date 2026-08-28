extends Area3D

@onready var stair_direction: Marker3D = $StairDirection

@export var target_level: PackedScene
@export var target_position: Vector3

var transferring := false
var player_on_stairs: Player = null


func _on_body_entered(body: Node3D) -> void:
	var player = body.get_parent()

	if not player is Player:
		return

	player_on_stairs = player
	try_start_transition()


func _on_body_exited(body: Node3D) -> void:
	var player = body.get_parent()

	if player == player_on_stairs:
		player_on_stairs = null


func _physics_process(_delta: float) -> void:
	if player_on_stairs and not transferring:
		try_start_transition()


func try_start_transition() -> void:
	if not player_on_stairs:
		return

	if not is_player_facing_stairs(player_on_stairs):
		return

	start_transition(player_on_stairs)


func is_player_facing_stairs(player: Player) -> bool:
	var player_forward := -player.global_transform.basis.z
	var stair_forward := -stair_direction.global_transform.basis.z

	player_forward.y = 0.0
	stair_forward.y = 0.0

	player_forward = player_forward.normalized()
	stair_forward = stair_forward.normalized()

	return player_forward.dot(stair_forward) > 0.99


func start_transition(player: Player) -> void:
	if transferring:
		return

	transferring = true
	player.is_transitioning = true
	player.move_queue.clear()

	# If the movement that put us onto the stair cell is still finishing,
	# let it reach the cell center first.
	if player.tween and player.tween.is_running():
		await player.tween.finished

	# Player may have turned again while we were waiting.
	if not is_player_facing_stairs(player):
		transferring = false
		player.is_transitioning = false
		return

	player.animation.play("go_down_stairs2")
	player.sfx_stairs.play()

	var finished_animation = await player.animation.animation_finished

	if finished_animation != "go_down_stairs2":
		transferring = false
		player.is_transitioning = false
		return

	get_tree().current_scene.change_level(
		target_level,
		target_position
	)

	player.is_transitioning = false

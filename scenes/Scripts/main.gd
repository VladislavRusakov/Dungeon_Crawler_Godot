extends Node

@onready var level = $Level
@onready var player = $Player


func change_level(
	new_level_scene: PackedScene,
	new_player_position: Vector3
) -> void:
	var old_level = level

	var new_level = new_level_scene.instantiate()
	add_child(new_level)

	old_level.queue_free()

	level = new_level
	level.name = "Level"

	player.global_position = new_player_position

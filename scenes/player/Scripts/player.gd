extends Node3D

signal toggle_inventory()

const TRAVEL_TIME := 0.4
const TURN_TIME := 0.2
const MAX_ACTIONS_REMEMBER = 3

@onready var front_ray := $FrontRay
@onready var back_ray := $BackRay
@onready var left_ray := $LeftRay
@onready var right_ray := $RightRay
@onready var animation := $animation
@onready var sfx_step_1 = $sfx_step1
@onready var sfx_step_2 = $sfx_step2
@onready var sfx_step_3 = $sfx_step3
@onready var sfx_movement_fail = $sfx_movement_fail
@onready var sfx_stairs = $sfx_stairs

@onready var map = $"../Map"
@onready var sfx_map_open = $"../Map/sfx_map_open"
@onready var sfx_map_close = $"../Map/sfx_map_close"

@onready var pause_menu = $PauseMenu

@onready var compas = $Compas

@export var inventory_data: InventoryData


var tween
var move_queue: Array = []
var is_moving := false
var is_bump_locked := false

func _ready():
	add_to_group("player")

func play_step_sound():
	# plays random footstep sound
	var step_sounds = [sfx_step_1, sfx_step_2, sfx_step_3]
	var sound = step_sounds[randi() % step_sounds.size()]
	sound.play()

func _physics_process(_delta):
	if is_moving:
		_store_direction_input()
		return

	while move_queue.size() > 0:
		var direction = move_queue.pop_front()
		_start_movement(direction)
		return

	_check_and_move()

func _store_direction_input():
	if Input.is_action_just_pressed("forward"):
		_enqueue_action("forward")
	elif Input.is_action_just_pressed("back"):
		_enqueue_action("back")
	elif Input.is_action_just_pressed("left"):
		_enqueue_action("left")
	elif Input.is_action_just_pressed("right"):
		_enqueue_action("right")
	elif Input.is_action_just_pressed("rotate_left"):
		_enqueue_action("rotate_left")
	elif Input.is_action_just_pressed("rotate_right"):
		_enqueue_action("rotate_right")

func _enqueue_action(action: String):
	if move_queue.size() >= MAX_ACTIONS_REMEMBER:
		move_queue.pop_front()  # Remove the oldest action
	move_queue.append(action)

func _check_and_move():
	if Input.is_action_just_pressed("forward"):
		_start_movement("forward")
	elif Input.is_action_just_pressed("back"):
		_start_movement("back")
	elif Input.is_action_just_pressed("left"):
		_start_movement("left")
	elif Input.is_action_just_pressed("right"):
		_start_movement("right")
	elif Input.is_action_just_pressed("rotate_left"):
		_start_movement("rotate_left")
	elif Input.is_action_just_pressed("rotate_right"):
		_start_movement("rotate_right")

func play_bump_feedback(direction: String):
	if is_bump_locked:
		return
	is_bump_locked = true
	
	match direction:
		"left":
			animation.play("left_blocked")
		"right":
			animation.play("right_blocked")
		"forward":
			animation.play("forward_blocked")
		"back":
			animation.play("back_blocked")
	
	sfx_movement_fail.play()
	
	#The animation duration is tied to TRAVEL_TIME by hand
	await get_tree().create_timer(TRAVEL_TIME + 1).timeout
	is_bump_locked = false

func _start_movement(direction: String):
	is_moving = true
	var did_move := false  # NEW: Track if movement was added

	match direction:
		"forward":
			front_ray.force_raycast_update()
			if not front_ray.is_colliding():
				tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(self, "transform", transform.translated(-transform.basis.z * 2), TRAVEL_TIME)
				animation.play("headbob")
				play_step_sound()
				did_move = true
			else:
				play_bump_feedback("forward")
		"back":
			if not back_ray.is_colliding():
				tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(self, "transform", transform.translated(transform.basis.z * 2), TRAVEL_TIME)
				animation.play("headbob")
				play_step_sound()
				did_move = true
			else:
				play_bump_feedback("back")
		"left":
			if not left_ray.is_colliding():
				tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(self, "transform", transform.translated(-transform.basis.x * 2), TRAVEL_TIME)
				animation.play("headbob")
				play_step_sound()
				did_move = true
			else:
				play_bump_feedback("left")
		"right":
			if not right_ray.is_colliding():
				tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(self, "transform", transform.translated(transform.basis.x * 2), TRAVEL_TIME)
				animation.play("headbob")
				play_step_sound()
				did_move = true
			else:
				play_bump_feedback("right")
		"rotate_left":
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, PI/2), TURN_TIME)
			did_move = true
		"rotate_right":
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, -PI/2), TURN_TIME)
			did_move = true

	if did_move:
		tween.connect("finished", Callable(self, "_on_movement_finished"))
	else:
		# If no movement tween created, reset manually
		is_moving = false

func _on_movement_finished():
	is_moving = false

func _input(event):
	if event.is_action_pressed("map"):
		if sfx_map_open.stream and sfx_map_close:
			if not map.visible:
				sfx_map_open.play()
			else:
				sfx_map_close.play()
		map.visible = !map.visible

	if event.is_action_pressed("menu"):
		if pause_menu.main_buttons.visible == false:
			pause_menu.pause_menu_called()
		else:
			pause_menu.pause_menu_closed()

	if event.is_action_pressed("compass"):
		compas.compass_draw()

	if event.is_action_pressed("inventory"):
		toggle_inventory.emit()

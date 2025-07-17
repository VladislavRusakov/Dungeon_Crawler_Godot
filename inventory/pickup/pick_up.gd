extends RigidBody3D

@export var slot_data: SlotData

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var sfx_pickup: AudioStreamPlayer = $sfx_pickup


func _ready() -> void:
	sprite_3d.texture = slot_data.item_data.texture
	
	
func _physics_process(delta: float) -> void:
	sprite_3d.rotate_y(delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	var player = body.get_parent()
	if player is Player:
		if player.inventory_data.pick_up_slot_data(slot_data):
			player.sfx_pickup.play()
			queue_free()

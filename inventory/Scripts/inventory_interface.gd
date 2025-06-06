extends Control

var grabbed_slot_data: SlotData

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var player = $"../.."
@onready var inventory_interface = $"."


func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)


func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)


func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)
	
	
func on_inventory_interact(inventory_data: InventoryData,
		index: int, button: int) -> void:
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			pass
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()


func toggle_inventory_interface() -> void:
	inventory_interface.visible = !inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

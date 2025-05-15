extends Control

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var player = $"../.."
@onready var inventory_interface = $"."


func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)


func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)
	
	
func on_inventory_interact(inventory_data: InventoryData,
		index: int, button: int) -> void:
	print("%s %s %s" % [inventory_data, index, button])


func toggle_inventory_interface() -> void:
	inventory_interface.visible = !inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

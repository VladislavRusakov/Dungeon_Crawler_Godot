extends Node3D

@onready var torch_light: OmniLight3D = $OmniLight3D
var base_energy := 1.0
var flicker_timer := 0.0

func _ready():
	torch_light.light_energy = base_energy

func _process(delta):
	flicker_timer += delta
	if flicker_timer >= 0.05:
		flicker_timer = 0
		var flicker = randf_range(-0.5, 0.5)
		torch_light.light_energy = base_energy + flicker
		

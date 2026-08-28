extends OmniLight3D

const FLICKER_LIGHT_INTENSITY := 0.02

var base_light_energy := 0.1
var flicker_timer := 0.0

func _ready():
	light_energy = base_light_energy

func _process(delta):
	flicker_timer += delta
	if flicker_timer >= 0.09:
		flicker_timer = 0
		var flicker = randf_range(-FLICKER_LIGHT_INTENSITY, FLICKER_LIGHT_INTENSITY)
		light_energy = base_light_energy + flicker

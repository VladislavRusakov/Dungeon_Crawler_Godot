extends OmniLight3D

const FLICKER := 1

var base_energy := 3.0
var flicker_timer := 0.0

func _ready():
	light_energy = base_energy

func _process(delta):
	flicker_timer += delta
	if flicker_timer >= 0.05:
		flicker_timer = 0
		var flicker = randf_range(-FLICKER, FLICKER)
		light_energy = base_energy + flicker

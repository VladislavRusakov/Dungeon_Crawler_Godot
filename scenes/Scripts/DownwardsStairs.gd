extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "PlayerBody":
		var player = body.get_parent()
		print(player)
		player.animation.play("go_down_stairs2")
		player.sfx_stairs.play()

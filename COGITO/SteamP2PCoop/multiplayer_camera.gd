extends Camera3D

func _ready():
	if is_multiplayer_authority():
		current = true
	else:
		current = false


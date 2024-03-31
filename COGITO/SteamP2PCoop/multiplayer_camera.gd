extends Camera3D


func _ready():
	current = is_multiplayer_authority()

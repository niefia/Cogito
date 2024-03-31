extends MultiplayerSpawner

@export var player_scene : PackedScene

## dictionaries cannot be statically typed
## key will be a variant data representing a player, key will be a node which is the player's node
var players = {}


func _ready():
	spawn_function = _spawn_player
	if is_multiplayer_authority():
		spawn(1)
		
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(_despawn_player)


func _spawn_player(id = 1) -> Node:
	var player : Node = player_scene.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	players[id] = player
	
	if multiplayer.is_server():
		print("SERVER: Player spawned with id: " + str(id))
	else:
		print("CLIENT: Player spawned with id: " + str(id))
		
	return player


func _despawn_player(id):
	players[id].queue_free()
	
	if multiplayer.is_server():
		print("SERVER: Player despawned with id: " + str(id))
	else:
		print("CLIENT: Player despawned with id: " + str(id))
	
	players.erase(id)

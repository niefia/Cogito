extends MultiplayerSpawner

@export var player_scene : PackedScene

## dictionaries cannot be statically typed
## key will be an integer representing a player id, key will be a node which is the player's node
var players = {}

func _ready():
	spawn_function = _spawn_player
	if is_multiplayer_authority():
		spawn(1)
		
		multiplayer.peer_connected.connect(_spawn_player)
		multiplayer.peer_disconnected.connect(_despawn_player)

func _spawn_player(id : int) -> Node:
	var player : Node = player_scene.instantiate()
	player.set_multiplayer_authority(id)
	players[id] = player
	return player

func _despawn_player(id : int):
	players[id].queue_free()
	players.erase(id)

extends Node

@export var start_level : PackedScene

@onready var multiplayer_spawner = $"../MultiplayerSpawner"

var lobby_id : int = 0
var peer : SteamMultiplayerPeer = SteamMultiplayerPeer.new()

func _ready():
	multiplayer_spawner.spawn_function = _spawn_level
	peer.lobby_created.connect(_on_lobby_created)

func _spawn_level(packed_scene_path : String) -> Node:
	var scene : Node = load(packed_scene_path).instantiate()
	return scene

func _on_host_button_pressed():
	## TODO: allow host to set the lobby visibility
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	multiplayer_spawner.spawn(start_level.resource_path)
	$HostButton.hide()

func _on_lobby_created(connection_status, id):
	if connection_status:
		lobby_id = id
		## TODO: Allow host to set Lobby Name
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName() + "'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)

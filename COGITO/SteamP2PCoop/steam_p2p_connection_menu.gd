extends Node

@export var start_level : PackedScene
@export var multiplayer_level_spawner : MultiplayerSpawner
@export var ui_parent : Node
@export var lobbies_container : Container

var lobby_id : int = 0
var steam_peer := SteamMultiplayerPeer.new()
var enet_peer := ENetMultiplayerPeer.new()


## TODO: HUD
## TODO: Escape Menu
## TODO: Make interface part of the escape menu tabs
## TODO: Support dynamically making a game into a MP instance from SP
## TODO: Make Steam/LAN some kind of toggle
## TODO: Move LAN to a separate menu and script
## TODO: Allow clients to set a LAN IP to join
## TODO: Add Callbacks with logs for connected_to_server, connection failed, server disconnected


func _ready():
	multiplayer_level_spawner.spawn_function = _spawn_level
	steam_peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	open_lobby_list()
	multiplayer_level_spawner.add_spawnable_scene("res://COGITO/SteamP2PCoop/MP_Demo_Level.tscn")


## called when the level is spawned by the multiplayer spawner
func _spawn_level(packed_scene_path : String) -> Node:
	var scene : Node = load(packed_scene_path).instantiate()
	return scene


#region Steam
func _on_host_steam_button_pressed():
	## TODO: allow host to set the lobby visibility
	steam_peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = steam_peer
	multiplayer_level_spawner.spawn(start_level.resource_path)

## once the host button has been pressed, and the lobby is created, this will end up being called
func _on_lobby_created(connection_status, id):
	if connection_status:
		lobby_id = id
		## TODO: Allow host to set Lobby Name
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName() + "'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		ui_parent.hide()


## used when clicking a related lobby button
func join_lobby(id : int):
	steam_peer.connect_lobby(id)
	multiplayer.multiplayer_peer = steam_peer
	lobby_id = id
	ui_parent.hide()


## used to get a list of available lobbies to join
func open_lobby_list():
	## TODO: Allow users to filter lobby list in different ways
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()


## show the list of available lobbies
func _on_lobby_match_list(lobbies):
	## lobby is a lobby id
	for lobby : int in lobbies:
		## get the name of the lobby
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var member_count = Steam.getNumLobbyMembers(lobby)
		
		var button : Button = Button.new()
		button.set_text(str(lobby_name) + " | Player Count: " + str(member_count))
		button.set_size(Vector2(100,5))
		button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		
		lobbies_container.add_child(button)


func _on_refresh_button_pressed():
	if lobbies_container.get_child_count() > 0:
		for child in lobbies_container.get_children():
			child.queue_free()
	
	open_lobby_list()
#endregion


#region LAN
func _on_host_lan_button_pressed():
	## TODO: Allow host to set port
	enet_peer.create_server(1027)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer_level_spawner.spawn(start_level.resource_path)
	ui_parent.hide()


func _on_join_localhost_button_pressed():
	## TODO: Allow client to define IP and port to join
	enet_peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer = enet_peer
	ui_parent.hide()

#endregion

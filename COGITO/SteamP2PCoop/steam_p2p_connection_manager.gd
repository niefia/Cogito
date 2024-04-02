class_name SteamP2PConnectionMenu
extends Node

var multiplayer_pause_menu : CogitoMultiplayerPauseMenu
var player_hud : CogitoPlayerHudManager
var multiplayer_player_spawner : MultiplayerPlayerSpawner

@export var multiplayer_hint_icon : Texture2D
@export var lobbies_container : Container

var lobby_id : int = 0
var steam_peer := SteamMultiplayerPeer.new()

# TODO: Friends Lobbies: https://godotsteam.com/tutorials/friends_lobbies/
# TODO: Fix the extra escape press needed after the menu is closed here and lan
# TODO: Close any open connections before joining or hosting
# TODO: Handle Disconnects

func _ready():
	multiplayer_pause_menu = get_tree().root.find_child("MultiplayerPauseMenu", true, false)
	player_hud = get_tree().root.find_child("Player_HUD", true, false)
	multiplayer_player_spawner = get_tree().root.find_child("MultiplayerPlayerSpawner", true, false)
	steam_peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_joined.connect(_on_lobby_joined)
	
	# TODO: Steam.join_requested.connect(_on_lobby_join_requested)
	# TODO: Steam.lobby_chat_update.connect(_on_lobby_chat_update)
	# TODO: Steam.lobby_data_update.connect(_on_lobby_data_update)
	# TODO: Steam.lobby_invite.connect(_on_lobby_invite)
	# TODO: Steam.lobby_message.connect(_on_lobby_message)
	# TODO: Steam.persona_state_change.connect(_on_persona_change)


## used to get a list of available lobbies to join
func open_lobby_list():
	## clear any previous lobbies
	if lobbies_container.get_child_count() > 0:
		for child in lobbies_container.get_children():
			child.queue_free()
	
	
	## TODO: Search filters: https://godotsteam.com/tutorials/lobbies/
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
	print("Requesting Steam Lobby List")


## show the list of available lobbies when received from steam callback
func _on_lobby_match_list(lobbies):
	print("Steam Lobby list received")
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


func _on_host_steam_button_pressed():
	## TODO: Allow host to set lobby visibility
	## TODO: Support Steam Invites
	## TODO: Allow lobby passwords
	## TODO: Set max players
	## lobby types: https://godotsteam.com/tutorials/lobbies/
	steam_peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC, 32)
	multiplayer.multiplayer_peer = steam_peer
	print("Starting Host...")
	player_hud._on_set_hint_prompt(multiplayer_hint_icon, "Starting Host...")
	## TODO: Show a message or dialogue about opening a server


## once the host button has been pressed, and the lobby is created, this will end up being called
func _on_lobby_created(connection_status, id):
	if connection_status:
		lobby_id = id
		## TODO: Allow the host to change the lobby name
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName() + "'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		multiplayer_pause_menu.close_pause_menu()
		print("Lobby Created Successfully")
		player_hud._on_set_hint_prompt(multiplayer_hint_icon, "Lobby Created Successfully")
		
		#spawn the host player
		multiplayer_player_spawner.spawn_player()


## used when clicking a related lobby button
func join_lobby(id : int):
	steam_peer.connect_lobby(id)
	multiplayer.multiplayer_peer = steam_peer
	lobby_id = id
	print("Joining Lobby:%s" % id)
	player_hud._on_set_hint_prompt(multiplayer_hint_icon, "Joining Lobby...")

func _on_lobby_joined(_this_lobby_id: int, _permissions: int, _locked: bool, _response: int):
	## TODO: Add a Cogito log
	multiplayer_pause_menu.close_pause_menu()
	print("Lobby Joined Successfully")
	player_hud._on_set_hint_prompt(multiplayer_hint_icon, "Lobby Joined Successfully")
	
	#spawn the client player
	multiplayer_player_spawner.spawn_player()

## called by the refresh button in the ui
func _on_refresh_button_pressed():
	open_lobby_list()

class_name MultiplayerTabMenu


extends TabContainer

@export var nodes_to_focus: Array[Control]
@export var steam_p2p_connection_menu : SteamP2PConnectionMenu

## called by the pause menu when this menu is opened
func refresh_servers():
	steam_p2p_connection_menu.open_lobby_list()

func _input(event):
	if !visible:
		return
	
	#Tab navigation
	if (event.is_action_pressed("ui_next_tab")):
		if current_tab + 1 == get_tab_count():
			current_tab = 0
		else:
			current_tab += 1
			
		if nodes_to_focus[current_tab]:
			#print("Grabbing focus of : ", tab_container.current_tab, " - ", nodes_to_focus[tab_container.current_tab])
			nodes_to_focus[current_tab].grab_focus.call_deferred()
		
	if (event.is_action_pressed("ui_prev_tab")):
		if current_tab  == 0:
			current_tab = get_tab_count()-1
		else:
			current_tab -= 1
			
		if nodes_to_focus[current_tab]:
			#print("Grabbing focus of : ", tab_container.current_tab, " - ", nodes_to_focus[tab_container.current_tab])
			nodes_to_focus[current_tab].grab_focus.call_deferred()

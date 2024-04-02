class_name CogitoMultiplayerPauseMenu
extends CogitoPauseMenuController

@export var multiplayer_tab_menu: MultiplayerTabMenu

func open_multiplayer_menu():
	multiplayer_tab_menu.show()
	multiplayer_tab_menu.nodes_to_focus[0].grab_focus.call_deferred()
	multiplayer_tab_menu.refresh_servers()
	game_menu.hide()

func open_pause_menu():
	super()
	get_tree().paused = false

func _input(event):
	if (event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause")) and !game_menu.visible:
		multiplayer_tab_menu.hide()
	
	super(event)

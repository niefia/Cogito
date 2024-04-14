class_name CogitoDoorSyncrhonizer
extends Node

@export var level_spawner : MultiplayerLevelSpawner

var door_array

func _on_multiplayer_level_spawner_level_loaded():
	door_array = level_spawner.find_children("", "CogitoDoor", true, false)
	for door in door_array:
		door.door_state_changed.connect(_on_door_state_changed.bind(door))

func _on_door_state_changed(is_open : bool, node : Node):
	## index in array assures we will find the unique door
	## as long as all instances get the same order array
	rpc_on_state_changed.rpc(is_open, door_array.find(node))

@rpc("any_peer", "call_remote", "reliable")
func rpc_on_state_changed(is_open : bool, door_index : int):
	if door_index == -1:
		printerr("CogitoDoorSynchronizer: Received switch RPC for node with id -1. 
				The node was not found in the array")
		return
	print ("received door RPC for door with id: %s" % door_index)
	_set_door_state(door_index, is_open)

func _set_door_state(door_index : int, is_open : bool):
	if not door_array[door_index].is_open == is_open:
		if is_open:
			door_array[door_index].open_door(null)
		else:
			door_array[door_index].close_door(null)

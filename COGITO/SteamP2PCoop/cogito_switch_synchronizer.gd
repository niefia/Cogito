class_name CogitoSwitchSynchronizer
extends Node

@export var level_parent : Node

var switch_array

func on_level_loaded():
	switch_array = level_parent.find_children("", "CogitoSwitch", true, false)
	for switch in switch_array:
		switch.switched.connect(_on_switch.bind(switch))

func _on_switch(is_on : bool, node : Node):
	## index in array assures we will find the unique switch
	## as long as all instances get the same order array
	rpc_on_switch.rpc(is_on, switch_array.find(node))

@rpc("any_peer", "call_remote", "reliable")
func rpc_on_switch(is_on : bool, switch_index : int):
	if switch_index == -1:
		printerr("Received switch RPC for switch with id -1. 
				The switch was not found in the switch_array")
		return
	print ("received switch RPC for switch with id: %s" % switch_index)
	if not switch_array[switch_index].is_on == is_on:
		## just calling switch again results in recursive signals
		## calling the specific on or off functions will not play a sound effect
		switch_array[switch_index].audio_stream_player_3d.play()
		if is_on:
			switch_array[switch_index].switch_on()
		else:
			switch_array[switch_index].switch_off()

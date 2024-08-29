@tool
extends CogitoDoor

var audiostreamplayer: AudioStreamPlayer3D
var cogito_door : AnimatableBody3D
var interactor : InteractionComponent

func _func_godot_apply_properties(props: Dictionary) -> void:
	
	#Apply audio properties
	open_sound = load(props["open_sound"])
	close_sound = load(props["close_sound"])
	rattle_sound = load(props["rattle_sound"])
	unlock_sound = load(props["unlock_sound"])
	
	#Apply Door Settings
	is_open = props["is_open"]
	interaction_text_when_locked = props["interaction_text_when_locked"]
	interaction_text_when_closed = props["interaction_text_when_closed"]
	interaction_text_when_open = props["interaction_text_when_open"]
	is_locked = props["is_locked"]
	#key = props["key"]
	#key_hint = props["key_hint"]
	#doors_to_sync_with = props["doors_to_sync_with"]
	#auto_close_time = props["auto_close_time"]
	
	#Apply Door parameters
	#door_type = DoorType.ROTATING
	#door_type = props["door_type"]
	#use_z_axis = props["use_z_axis"]
	#bidirectional_swing = props["bidirectional_swing"]
	#open_rotation_deg = props["open_rotation_deg"]
	#closed_rotation_deg = props["closed_rotation_deg"]
	#door_speed = props["door_speed"]
	
	
	open_rotation_deg = 90
	closed_rotation_deg = 0

func _func_godot_build_complete():
	#Setup Door node properties
	set_name("CogitoDoor")
	
	#Add Audiostream child node
	audiostreamplayer = AudioStreamPlayer3D.new()
	add_child(audiostreamplayer)
	audiostreamplayer.set_owner(get_owner())
	audiostreamplayer.set_name("AudioStreamPlayer3D")
	audiostreamplayer.volume_db = -26
	
	
	#Add interactor child node
	interactor = InteractionComponent.new()
	add_child(interactor)
	interactor.set_owner(get_owner())
	interactor.set_name("BasicInteraction")
	interactor.set_script(load("res://COGITO/Components/Interactions/BasicInteraction.gd"))
	
	# Set properties for the interactor
	interactor.input_map_action = "interact"
	interactor.interaction_text = "Interact"
	interactor.is_disabled = false
	interactor.ignore_open_gui = true





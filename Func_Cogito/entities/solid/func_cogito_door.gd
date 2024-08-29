@tool
extends CogitoDoor

var audiostreamplayer: AudioStreamPlayer3D
var cogito_door : AnimatableBody3D
var interactor : InteractionComponent

func _func_godot_build_complete():
	set_name("CogitoDoor")

	open_sound = load("res://COGITO/Assets/Audio/Kenney/doorOpen_1.ogg")
	close_sound = load("res://COGITO/Assets/Audio/Kenney/doorClose_4.ogg")
	# rattle_sound = load("")
	# unlock_sound = load("")

	audiostreamplayer = AudioStreamPlayer3D.new()
	add_child(audiostreamplayer)
	audiostreamplayer.set_owner(get_owner())
	audiostreamplayer.set_name("AudioStreamPlayer3D")
	
	
	interactor = InteractionComponent.new()
	#cogito_door.add_child(interactor)
	add_child(interactor)
	interactor.set_owner(get_owner())
	interactor.set_name("BasicInteraction")
	interactor.set_script(load("res://COGITO/Components/Interactions/BasicInteraction.gd"))
	
	# Set properties for the interactor
	interactor.input_map_action = "interact"
	interactor.interaction_text = "Interact"
	interactor.is_disabled = false
	interactor.ignore_open_gui = true





@tool
extends CogitoSwitch

var audiostreamplayer : AudioStreamPlayer3D
var interactor : InteractionComponent
var omnilight : OmniLight3D

@export var target: String = ""
@export var targetfunc: String = ""
@export var targetname: String = ""

func _func_godot_apply_properties(props: Dictionary) -> void:
	target = props["target"] as String
	targetfunc = props["targetfunc"] as String
	targetname = props["targetname"] as String
	
func interact(_player_interaction_component):
	super.interact(_player_interaction_component)
	GAME.use_targets(self, target)

		
func _func_godot_build_complete():
	
	#Setup Door node properties
	set_name("CogitoSwitch")
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
	

	#Add OmniLight3D child node
	omnilight = OmniLight3D.new()
	add_child(omnilight)
	omnilight.set_owner(get_owner())
	omnilight.set_name("OmniLight3D")
	omnilight.visible = false
	
	nodes_to_show_when_on.append(omnilight)



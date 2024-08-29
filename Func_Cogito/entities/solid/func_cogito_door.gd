@tool
extends CogitoDoor

var audiostreamplayer: AudioStreamPlayer3D
var cogito_door: AnimatableBody3D
var interactor: InteractionComponent
var pivot_node: Node3D # Node for pivot point

func _func_godot_apply_properties(props: Dictionary) -> void:
	# Apply audio properties
	open_sound = load(props["open_sound"])
	close_sound = load(props["close_sound"])
	rattle_sound = load(props["rattle_sound"])
	unlock_sound = load(props["unlock_sound"])

	# Apply Door Settings
	is_open = props["is_open"]
	interaction_text_when_locked = props["interaction_text_when_locked"]
	interaction_text_when_closed = props["interaction_text_when_closed"]
	interaction_text_when_open = props["interaction_text_when_open"]
	is_locked = props["is_locked"]

	open_rotation_deg = 90
	closed_rotation_deg = 0

func _func_godot_build_complete():
	# Setup Door node properties
	set_name("CogitoDoor")

	# Add Audiostream child node
	audiostreamplayer = AudioStreamPlayer3D.new()
	add_child(audiostreamplayer)
	audiostreamplayer.set_owner(get_owner())
	audiostreamplayer.set_name("AudioStreamPlayer3D")
	audiostreamplayer.volume_db = -26

	# Add pivot node
	pivot_node = Node3D.new()
	add_child(pivot_node)
	pivot_node.set_owner(get_owner())
	pivot_node.set_name("PivotNode")

	# Add cogito_door as a child of pivot_node
	cogito_door = AnimatableBody3D.new()
	pivot_node.add_child(cogito_door)
	cogito_door.set_owner(get_owner())
	cogito_door.set_name("CogitoDoorModel")

	# Adjust the pivot_node's position to match the desired rotation point
	adjust_pivot()

	# Add interactor child node
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

func adjust_pivot():
	# Move the pivot_node to the left edge of the door
	var door_width = cogito_door.get_aabb().size.x
	pivot_node.translate_object_local(Vector3(door_width / 2, 0, 0))

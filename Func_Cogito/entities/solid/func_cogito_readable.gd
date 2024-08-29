@tool
extends CogitoStaticInteractable

var Readable: ReadableComponent

func _func_godot_apply_properties(props: Dictionary) -> void:
	set_name("CogitoReadableBrush")
	
	# Load the ReadableComponent scene
	var packed_scene: PackedScene = load("res://COGITO/Components/Interactions/ReadableComponent.tscn")
	
	# Instance the scene and add as a child
	Readable = packed_scene.instantiate() as ReadableComponent
	add_child(Readable)
	Readable.set_owner(get_owner())
	Readable.set_name("ReadableComponent")
	
	# Set properties for the Readable
	Readable.input_map_action = "interact"
	Readable.interaction_text = "Read"
	Readable.is_disabled = false
	Readable.ignore_open_gui = true
	
	# Set custom readable properties
	Readable.interact_sound = load("res://COGITO/Assets/Audio/Kenney/bookOpen.ogg")
	Readable.readable_title = "Title"
	Readable.readable_content = "You've found a Demo Hint!"
	
	Readable.interact_sound = load(props["interact_sound"])
	Readable.readable_title = props["readable_title"]
	Readable.readable_content = props["readable_content"]

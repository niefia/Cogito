@tool
extends CogitoDoor


var Health: CogitoHealthAttribute
var Hitbox: Node

func _func_godot_apply_properties(props: Dictionary) -> void:
	set_name("CogitoBreakable")
	
	#Add CogitoHealthAttribute child node
	Health = CogitoHealthAttribute.new()
	add_child(Health)
	Health.set_owner(get_owner())
	
	#Set external properties
	Health.sound_on_damage_taken = load(props["sound_on_damage_taken"])
	Health.sound_on_damage_taken = load(props["sound_on_death"])
	Health.value_max = props["value_max"]
	Health.value_start = props["value_start"]
	
	#Set attribute to be Health using defaults
	Health.set_name("CogitoHealth")
	Health.attribute_name = "health"
	Health.attribute_display_name = "Health"
	Health.attribute_color = "ba0000"
	Health.attribute_icon = load("res://COGITO/Assets/Graphics/UiIcons/Ui_Icon_Health.png")

	#Add Hitbox node
	Hitbox = Node.new()
	add_child(Hitbox)
	Hitbox.set_owner(get_owner())
	Hitbox.set_name("Hitbox")
	Hitbox.set_script(load("res://COGITO/Components/HitboxComponent.gd"))
	Hitbox.health_attribute = $CogitoHealth


#func _func_godot_build_complete():
	
	

func _ready():
	#Doesn't work to generate before runtime as it generates some sort of Temporary path instead
	var parent_node_path = get_path()
	$CogitoHealth.destroy_on_death.append(parent_node_path)


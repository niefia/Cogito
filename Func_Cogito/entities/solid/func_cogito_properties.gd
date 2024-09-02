@tool
extends CogitoProperties


var audiostreamplayer: AudioStreamPlayer3D
var damage_timer_node: Timer
var reaction_timer_node: Timer

func _func_godot_build_complete():
	
	#Add Audiostream child node
	audiostreamplayer = AudioStreamPlayer3D.new()
	audiostreamplayer.set_name("AudioStreamPlayer3D")
	add_child(audiostreamplayer)
	audiostreamplayer.set_owner(get_owner())
	audiostreamplayer.volume_db = -26

	#Add DamageTimer child node
	damage_timer_node = Timer.new()
	damage_timer_node.set_name("DamageTimer")
	add_child(damage_timer_node)
	damage_timer_node.set_owner(get_owner())
	damage_timer_node.one_shot = true

	#Add ReactionTimer child node
	reaction_timer_node = Timer.new()
	reaction_timer_node.set_name("ReactionTimer")
	add_child(reaction_timer_node)
	reaction_timer_node.set_owner(get_owner())
	reaction_timer_node.one_shot = true

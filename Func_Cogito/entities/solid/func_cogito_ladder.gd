@tool
extends StaticBody3D
	
var LadderParent : Area3D
var LadderStaticBody3D : StaticBody3D

func _func_godot_build_complete():
	
	LadderParent = Area3D.new()
	add_child(LadderParent)
	LadderParent.set_owner(get_owner())
	LadderParent.set_name("Ladder")
	LadderParent.set_script(load("res://COGITO/Scripts/ladder_area.gd"))
	
	LadderStaticBody3D = StaticBody3D.new()
	LadderParent.add_child(LadderStaticBody3D)
	LadderStaticBody3D.set_owner(get_owner())
	LadderStaticBody3D.set_name("LadderStat")

	for child in get_children():
		if child is CollisionShape3D:
			var ladder_area = child.duplicate()
			#creates ladder interaction area, need to make this user adjustable to choose axis and displacement
			ladder_area.transform.origin.x -= 0.1
			LadderParent.add_child(ladder_area)
			ladder_area.set_owner(get_owner())
			ladder_area.set_name("ladderArea")
	




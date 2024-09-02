@tool
extends OmniLight3D

func _ready():
	GAME.set_targetname(self, targetname)

@export var targetname: String = ""

func _func_godot_apply_properties(props: Dictionary) -> void:
	targetname = props["targetname"] as String
	

func switch():
	self.visible = not self.visible

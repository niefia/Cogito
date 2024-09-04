class_name WaterFill
extends Node3D


##Time in seconds for the water to fill up
@export var water_fill_time : float = 5.0 
## Time in seconds for the water to drain
@export var water_drain_time : float = 10.0  
# Maximum height of the water level
@export var water_level_max_height : float = 0.7  

@onready var _water_mesh : MeshInstance3D = $WaterPlane
@onready var _audio_stream : AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var _waterfall : Node3D = $WaterFall
@onready var _waterfall2 : Node3D =$WaterFall2
@onready var _waterImpact : Node3D = $WaterImpact
@onready var _wetZone : Node3D = $WetZone2
var _water_level_start_height : float

# Flags to track the sink state
var _tap_state : bool = false  # Tracks whether the tap is on or off
var _is_filling : bool = false
var _is_draining : bool = false

func _ready():
	_water_level_start_height = _water_mesh.transform.origin.y
	# Ensure effects are hidden at the start
	_set_effect_visibility(false)
	_water_mesh.visible = false  # Hide the water mesh initially

func _process(delta: float) -> void:
	if _is_filling:
		_fill_sink(delta)
	elif _is_draining:
		_drain_sink(delta)

func interact(_player_interaction_component = null) -> void:
	# Toggle the tap state
	_tap_state = not _tap_state
	
	if _tap_state:
		# Turn on the tap: Start filling, stop draining
		_is_filling = true
		_is_draining = false
		_audio_stream.play()
		_set_effect_visibility(true)
		_water_mesh.visible = true  # Ensure water mesh is visible when filling starts
	else:
		# Turn off the tap: Stop filling, start draining
		_is_filling = false
		_is_draining = true
		_audio_stream.stop()
		_set_effect_visibility(false)

func _fill_sink(delta: float) -> void:
	var current_height = _water_mesh.transform.origin.y
	var target_height = _water_level_start_height + water_level_max_height
	
	# Check if water is not yet fully raised
	if current_height < target_height:
		var new_height = current_height + (water_level_max_height / water_fill_time) * delta
		new_height = min(new_height, target_height)  # Ensure it doesn't go beyond the target height
		
		# Update the water mesh position
		var transform = _water_mesh.transform
		transform.origin.y = new_height
		_water_mesh.transform = transform
	else:
		# If the water is fully raised, just stop filling
		_is_filling = false

		# Ensure WetZone gets wet when fully filled
		if is_instance_valid(_wetZone):
			var wet_zone_script = _wetZone.get_script()
			if wet_zone_script is CogitoObject:
				_wetZone.call("cogito_properties.make_wet")

func _drain_sink(delta: float) -> void:
	var current_height = _water_mesh.transform.origin.y
	var target_height = _water_level_start_height
	
	# Check if water is above the starting level
	if current_height > target_height:
		var new_height = current_height - (water_level_max_height / water_drain_time) * delta
		new_height = max(new_height, target_height)  # Ensure it doesn't go below the start height
		
		# Update the water mesh position
		var transform = _water_mesh.transform
		transform.origin.y = new_height
		_water_mesh.transform = transform
	else:
		# If the water is fully drained, stop draining and hide the water mesh
		_is_draining = false
		_water_mesh.visible = false  # Hide the water mesh when fully drained

		# Ensure WetZone becomes dry when fully drained
		if is_instance_valid(_wetZone):
			var wet_zone_script = _wetZone.get_script()
			if wet_zone_script is CogitoObject:
				_wetZone.call("cogito_properties.make_dry")

func _set_effect_visibility(visible: bool) -> void:
	# Set the visibility of the water effects
	_waterfall.visible = visible
	_waterfall2.visible = visible
	_waterImpact.visible = visible
	#wetZone breaks on scene reload TODO: Figure out cause, and fix this
	if is_instance_valid(_wetZone):
		_wetZone.visible = visible

	

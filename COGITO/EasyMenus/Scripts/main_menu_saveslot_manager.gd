extends Control

@onready var save_slot_a: CogitoSaveSlotButton = $"../ContentMain/GameMenu/VBoxContainer/SaveSlot_A"
@onready var save_slot_b: CogitoSaveSlotButton = $"../ContentMain/GameMenu/VBoxContainer/SaveSlot_B"
@onready var save_slot_c: CogitoSaveSlotButton = $"../ContentMain/GameMenu/VBoxContainer/SaveSlot_C"

## Filepath to the scene the player should start in, when pressing "Start game" button.
@export_file("*.tscn") var start_game_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_slot_a.set_data_from_state(load_slot_data("A"))
	save_slot_b.set_data_from_state(load_slot_data("B"))
	save_slot_c.set_data_from_state(load_slot_data("C"))


func load_slot_data(save_slot: String) -> CogitoPlayerState:
	# Set CSM active slot to slot to load
	CogitoSceneManager.switch_active_slot_to(save_slot)
	if CogitoSceneManager._player_state == null:
		return null
	else:
		return CogitoSceneManager._player_state
	

func start_new_game():
	if start_game_scene: 
		CogitoSceneManager.load_next_scene(start_game_scene, "", "temp", CogitoSceneManager.CogitoSceneLoadMode.RESET) #Load_mode 2 means there's no attempt to load a state.
	else:
		print("No start game scene set.")

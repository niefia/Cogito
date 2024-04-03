extends Node
## Setup Steam Environment, setup callbacks

## Set this to whatever your SteamAppID is. 480 will work fine for testing.
@export var SteamAppID : int = 480

## TODO: Setup main menu to run the MP demo
## TODO: Utilize Save and Load
## TODO: Add Callbacks for connected_to_server, connection failed, server disconnected
## TODO: Smoothing for current player synced variables
## TODO: Sync player held items, and rotation
## TODO: Player menu
## TODO: Vote kick
## TODO: Handle player death

func _ready():
	OS.set_environment("SteamAppID", str(SteamAppID))
	OS.set_environment("SteamGameID", str(SteamAppID))
	
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s " % initialize_response)
	
	## if steam did not initialize properly then shut down
	if initialize_response['status'] > 0:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)
		get_tree().quit()


func _process(_delta : float):
	Steam.run_callbacks()

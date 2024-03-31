extends Node

## Set this to whatever your SteamAppID is. 480 will work fine for testing.
@export var SteamAppID : int = 480


func _ready():
	OS.set_environment("SteamAppID", str(SteamAppID))
	OS.set_environment("SteamGameID", str(SteamAppID))
	Steam.steamInitEx()


func _process(_delta):
	Steam.run_callbacks()

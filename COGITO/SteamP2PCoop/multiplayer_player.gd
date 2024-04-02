extends CogitoPlayer

func _enter_tree():
	## when the game is starting single player mode we don't want to lose authority
	if not multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		set_multiplayer_authority(name.to_int())

func _input(event):
	if not is_multiplayer_authority():
		return
	super(event)

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	super(delta)

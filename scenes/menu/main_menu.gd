extends Node

@export var Address = "127.0.0.1"
@export var port = 8910
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func peer_connected(id):
	print("Player connected: " + str(id))

func peer_disconnected(id):
	print("Player disconnected: " + str(id))

func connected_to_server():
	print("Connected to server")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())

func connection_failed():
	print("Connection failed")
	
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !MultiplayerController.Players.has(id):
		MultiplayerController.Players[id] ={
			"name" : name,
			"id" : id,
			"score" : 0
		}
		
	if multiplayer.is_server():
		for i in MultiplayerController.Players:
			SendPlayerInformation.rpc(MultiplayerController.Players[i].name, i)

@rpc("any_peer", "call_local")

func StartGame():
	var scene = load("res://scenes/level/level1.tscn").instantiate()
	get_tree().root.add_child(scene)

func _on_host_pressed():
	
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print("Cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())

func _on_join_pressed():
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_level_1_pressed():
	#get_tree().change_scene_to_file("res://scenes/level/level1.tscn")
	#print("Host")
	StartGame.rpc()

func _on_quit_pressed():
	get_tree().quit()

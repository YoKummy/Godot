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

func connection_failed():
	print("Connection failed")

func _on_host_pressed():
	
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print("Cannot host: " + str(error))
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	get_tree().multiplayer.multiplayer_peer = peer


func _on_join_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level1.tscn")
	print("Join")
	
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(Address, port)
	if error != OK:
		print("Cannot join: " + str(error))
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level1.tscn")
	print("Host")

func _on_quit_pressed():
	get_tree().quit()

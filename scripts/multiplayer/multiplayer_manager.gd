extends Node

const PORT = 8080
const SERVER_IP = "127.0.0.1"
var server_peer
var client_peer
@export var player_scene: PackedScene

func _ready():
	if player_scene == null:
		print("Error: player_scene is not assigned.")
	else:
		print("player_scene is assigned correctly.")

func become_host():
	print("Start hosting")

	server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)

func _add_player_to_game(id: int):
	print("%s joined" % id)
	
	if player_scene == null:
		print("Error: player_scene is null when trying to instantiate.")
		return
	
	var player = player_scene.instantiate()
	player.name = str(id)
	
	call_deferred("add_child", player)
	
func join_host():
	print("Joining")
	
	client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, PORT)
	
	multiplayer.multiplayer_peer = client_peer

func _del_player(id: int):
	print("%s left" % id)

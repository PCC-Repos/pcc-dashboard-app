extends Node

var client: PCFClient
var rest: PCFRESTClient
var ws: PCFWSClient

func _ready() -> void:
	client = PCFClient.new()
	add_child(client)

	rest = client.get_rest_client()
	ws = client.get_ws_client()

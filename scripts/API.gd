extends Node

var client: PCFClient
var rest: PCFRESTClient

func _ready() -> void:
	client = PCFClient.new()
	add_child(client)
	client.set_debug(true)

	rest = client.get_rest_client()

extends Control

signal access_token_received(access_token)

var api_base

var us_email
var us_pass

onready var us_name_node = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LineEdit
onready var us_pass_node = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/LineEdit

# Called when the node enters the scene tree for the first time.
func ready():
	prints("got api base", api_base)



func _on_Login_pressed():
	us_email = us_name_node.text
	us_pass = us_pass_node.text
	
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_request_completed", [http_req])
	var data = {
		"email_id": us_email,
		"password": us_pass
	}
	add_child(http_req)
	http_req.request(api_base + "auth/authorize/", PoolStringArray(), true, HTTPClient.METHOD_POST, to_json(data))

func _request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req):
	http_req.queue_free()
	if response_code != 200:
		prints(response_code, "Something went wrong, plz check!")
		if response_code == 401:
			prints(headers)
		return
	
	var res = parse_json(body.get_string_from_utf8())
	if res.has("access_token"):
		emit_signal("access_token_received", res["access_token"])
	
	save_access_token(res)

func save_access_token(res: Dictionary):
	pass

extends Panel

signal access_token_received(access_token)
signal show_register_modal

var api_base

var us_email
var us_pass

onready var us_name_node = $"HBoxContainer/VBoxContainer/Email"
onready var us_pass_node = $"HBoxContainer/VBoxContainer/Password"

# Called by my code.
func ready():
	prints("got api base", api_base)

# Called by the engine.
func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(768, 768))

func _on_Login_pressed():
	us_email = us_name_node.text
	us_pass = us_pass_node.text
	login()

func login():
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


func _on_Register_pressed():
	emit_signal("show_register_modal")


func _on_RegisterModal_submit(_us_name, _us_email, _us_password):
	create_user_api(_us_name, _us_email, _us_password)
	us_pass = _us_password
	us_email = _us_email

func create_user_api(us_name, us_email, us_pass):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_create_user_api", [http_req])
	add_child(http_req)
	var dict = {"name": us_name, 'email': us_email, "password": us_pass}
	http_req.request(api_base + 'users/', PoolStringArray(["Content-Type: application/json"]), true, HTTPClient.METHOD_POST, to_json(dict))

func _create_user_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	login()

extends Control

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

#func _process(delta: float) -> void:
#	OS.set_window_title(str(OS.window_size))

# Called by the engine.
func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(768, 768))

func _on_Login_pressed():
	us_email = us_name_node.text
	us_pass = us_pass_node.text
	login()

func login(_us_email = us_email, _us_pass = us_pass):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_request_completed", [http_req])
	var data = {
		"email_id": _us_email,
		"password": _us_pass
	}
	add_child(http_req)
	http_req.request(api_base + "auth/authorize/", PoolStringArray(), true, HTTPClient.METHOD_POST, to_json(data))

func _request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req):
	http_req.queue_free()
	if response_code != 200:
		prints(response_code, "Something went wrong, plz check!")
		if response_code == 401:
			prints(headers)
			emit_signal("access_token_received", null)
		return

	var res = parse_json(body.get_string_from_utf8())
	if res.has("access_token"):
		emit_signal("access_token_received", res["access_token"])

	save_access_token(res)
	

func save_access_token(res: Dictionary):
	pass


func _on_Register_pressed():
	get_tree().current_scene.get_node("TabContainer").current_tab = get_tree().current_scene.get_node("TabContainer").find_node("RegisterForm").get_index()


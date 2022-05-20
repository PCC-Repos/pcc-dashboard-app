extends Control

const API_BASE = "https://api.proclubsfederation.com/v1/"
const DebugAPI_BASE = "http://127.0.0.1:8000/"


var api_base
var debug = false

var user
var logged_in = false
var access_token = ""
var headers = PoolStringArray()
var admin_form

func _ready():
	if OS.has_feature('debug') and debug:
		api_base = DebugAPI_BASE
	else:
		api_base = API_BASE
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(768, 768))
	prints("Using API base", api_base)
	get_tree().set_group("api_base", "api_base", api_base)
	get_tree().call_group("api_base", "ready")

func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			print("Quit request")
			get_tree().change_scene("res://closing_screen/closing_screen.tscn")
		NOTIFICATION_WM_GO_BACK_REQUEST:
			get_tree().change_scene("res://closing_screen/closing_screen.tscn")


func _on_LoginForm_access_token_received(_access_token):
	access_token = _access_token
	logged_in = true
	headers = PoolStringArray(["Authorization: Bearer %s" % access_token])
	fetch_current_user()


func fetch_current_user():
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_request_completed", [http_req])
	add_child(http_req)
	http_req.request((api_base + "users/@me/").http_unescape(), headers, true, HTTPClient.METHOD_GET)

func _request_completed(result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, http_req):
	http_req.queue_free()
	if response_code != 200:
		prints(response_code, "Something went wrong, plz check!")
		if response_code == 401:
			prints(headers)
		return

	var res = parse_json(body.get_string_from_utf8())
	user = res

	call_deferred("init_admin")

func init_admin():
	admin_form = load("res://forms/admin_form.tscn").instance()
	add_child(admin_form)


	get_tree().set_group("login_ready", "headers", headers)
	get_tree().set_group("login_ready", "api_base", api_base)
	get_tree().set_group("login_ready", "user", user)

	get_tree().call_group("login_ready", "ready")

	$LoginForm.hide()

func logged_out():
	get_tree().set_group("login_ready", "headers", PoolStringArray())
	get_tree().set_group("login_ready", "user", Dictionary())

	remove_child(admin_form)
	admin_form.queue_free()

	$LoginForm.show()

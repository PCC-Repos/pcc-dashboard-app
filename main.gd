extends Control

const API_BASE = "https://api.proclubsfederation.com/v2/"
const DebugAPI_BASE = "http://127.0.0.1:8000/"


export(bool) var debug: = true

var api_base
var user
var logged_in = false
var access_token = ""
var headers = PoolStringArray()
var admin_form

onready var notif = $NotifPopup

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

func fetch_current_user(refresh = false):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_request_completed", [http_req, refresh])
	add_child(http_req)
	http_req.request((api_base + "users/@me/").http_unescape(), headers, true, HTTPClient.METHOD_GET)

func _request_completed(result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, http_req, refresh: bool):
	http_req.queue_free()
	if response_code != 200:
		print_debug(response_code, "Something went wrong, plz check!")
		notif.text = "%s: Something went wrong, plz check!" % response_code
		if response_code == 401:
			print_debug(headers)
			self.notif.text = "Failed to Login.\nPlease check that you entered the details correctly or create a New Account."
		return

	var res = parse_json(body.get_string_from_utf8())
	user = res

	if not refresh:
		call_deferred("init_admin")
	else:
		get_tree().set_group("login_ready", "user", user)


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

func refresh():
	fetch_current_user(true)

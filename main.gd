extends Control

const API_BASE = "https://api.proclubsfederation.com/v2/"
const DebugAPI_BASE = "http://127.0.0.1:8000/"


export(bool) var debug: = true
export(float) var tween_duration: = 0.5

var api_base
var user
var access_token = ""
var headers = PoolStringArray()
var admin_form


func _ready():
	$"%Logo".hide()

	if OS.has_feature('debug') and debug:
		api_base = DebugAPI_BASE
	else:
		api_base = API_BASE
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(768, 768))
	prints("Using API base", api_base)
	get_tree().set_group("api_base", "api_base", api_base)
	get_tree().call_group("api_base", "ready")
	GlobalUserState.connect("logged_out", self, "logged_out")
	GlobalUserState.connect("logged_in", self, "logged_in")
	if GlobalUserState.user:
		$HBoxContainer.hide()
		logged_in()
		return
	else:
		$HBoxContainer.show()
		ready()


func ready():
	ready_tween()
	NotificationServer.notify_info("Welcome to PCF Dashboard!")

#func _notification(what):
#	match what:
#		NOTIFICATION_WM_QUIT_REQUEST:
#			print("Quit request")
## warning-ignore:return_value_discarded
#			get_tree().change_scene("res://closing_screen/closing_screen.tscn")
#		NOTIFICATION_WM_GO_BACK_REQUEST:
## warning-ignore:return_value_discarded
#			get_tree().change_scene("res://closing_screen/closing_screen.tscn")

func ready_tween():
	$"%Logo".show()
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_QUART).set_parallel()
# warning-ignore:return_value_discarded
	tween.tween_property($"%TabContainer", "rect_position:x", OS.window_size.x / 2 - (OS.window_size.y / 16), tween_duration).from(OS.window_size.x + 10)
# warning-ignore:return_value_discarded
	tween.tween_property($"%Logo", "rect_position:x", 50.0, tween_duration).from(-$"%ImageContainer".rect_size.x - 10)

#func _on_LoginForm_access_token_received(_access_token):
#	if !_access_token:
#		if debug:
#			NotificationServer.notify_critical("Bad Access Token Received: %s" % _access_token)
#		return
#	access_token = _access_token
#	logged_in = true
#	headers = PoolStringArray(["Authorization: Bearer %s" % access_token])
#	fetch_current_user()
#
#func fetch_current_user(refresh = false):
#	var http_req = HTTPRequest.new()
#	http_req.connect("request_completed", self, "_request_completed", [http_req, refresh])
#	add_child(http_req)
#	http_req.request((api_base + "users/@me/").http_unescape(), headers, true, HTTPClient.METHOD_GET)
#
#func _request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, http_req, refresh: bool):
#	http_req.queue_free()
#	if response_code != 200:
#		print_debug(response_code, " Something went wrong, plz check!")
#		NotificationServer.notify_critical("Something went wrong, please check! %s" % response_code)
#		if response_code == 401:
#			print_debug(headers)
#		logged_in = false
#		$HBoxContainer.show()
#		ready()
#		return
#
#	var res = parse_json(body.get_string_from_utf8())
#	user = res


func logged_in():
	$"%ImageContainer".get_node("CanvasLayer").visible = false


	call_deferred("init_admin")


func init_admin():
	admin_form = load("res://forms/admin_form.tscn").instance()
	add_child(admin_form)


	get_tree().set_group("login_ready", "headers", headers)
	get_tree().set_group("login_ready", "api_base", api_base)
	get_tree().set_group("login_ready", "user", user)

	get_tree().call_group("login_ready", "ready")

	$"%TabContainer".hide()

	$AudioStreamPlayer.stop()

func logged_out():
	print("logged out")
#	get_tree().set_group("login_ready", "headers", PoolStringArray())
#	get_tree().set_group("login_ready", "user", Dictionary())

	admin_form.queue_free()

	$"%TabContainer".show()
	$HBoxContainer.show()
	$"%ImageContainer".get_node("CanvasLayer").visible = true
	ready_tween()
	$"%TabContainer/LoginForm"._ready()
	$AudioStreamPlayer.play()

func refresh():
	pass
#	fetch_current_user(true)


func _on_Main_visibility_changed() -> void:
	$"%ImageContainer".get_node("CanvasLayer").visible = visible

func _on_TabContainer_tab_changed(_tab: int):
	ready_tween()

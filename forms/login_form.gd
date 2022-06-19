extends Control

signal access_token_received(access_token)
#signal show_register_modal

var api_base

var us_email
var us_pass

var registed_changed_once = false

onready var http: = $HTTPRequest
onready var us_name_node = $VBoxContainer/Email
onready var us_pass_node = $VBoxContainer/Password

# Called by my code.
func ready():
	prints("got api base", api_base)

#func _process(delta: float) -> void:
#	OS.set_window_title(str(OS.window_size))

var token_file
# Called by the engine.
func _ready():
	token_file = GlobalUserState.token_file
	$"%Login".disabled = false
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(768, 768))

func _on_Login_pressed():
	us_email = us_name_node.text
	us_pass = us_pass_node.text

	GlobalUserState.login(us_email, us_pass)

	$"%Login".disabled = true

func login(_us_email = us_email, _us_pass = us_pass):
	var data = {
		"email_id": _us_email,
		"password": _us_pass
	}
	http.request(api_base + "auth/authorize/", PoolStringArray(), true, HTTPClient.METHOD_POST, to_json(data))

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	if result == OK:
		if response_code != 200:
			print_debug(response_code, " Something went wrong, plz check!")
			$"%Login".disabled = false
			match response_code:
				HTTPClient.RESPONSE_UNAUTHORIZED:
					print_debug(headers)
					NotificationServer.notify_error("Failed to Login.\nPlease check that you entered the details correctly or create a New Account.")
					emit_signal("access_token_received", null)
				HTTPClient.RESPONSE_UNPROCESSABLE_ENTITY:
					NotificationServer.notify_error("Please enter a correct email address in the \"Email\" Field.")
			return
	else:
		print_debug("There was some error with the HTTPRequest Node. `result` = ", result)

	var res = parse_json(body.get_string_from_utf8())
	if res.has("access_token"):
		emit_signal("access_token_received", res["access_token"])

	GlobalUserState.save_access_token(res)



func _on_Register_pressed():
	if not registed_changed_once:
		NotificationServer.notify_info("Make a new account here!")
		registed_changed_once = true
	get_tree().current_scene.get_node("%TabContainer").current_tab = get_tree().current_scene.get_node("%TabContainer").find_node("RegisterForm").get_index()


func _on_ForgotPass_pressed():
	NotificationServer.notify_info("Not yet implemented.")

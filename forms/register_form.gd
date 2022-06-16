extends Control


var api_base

var us_email
var us_pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().current_scene.get_node("AnimationPlayer").play("LightsON")


func _on_BackButton_pressed() -> void:
	get_tree().current_scene.get_node("%TabContainer").current_tab = get_tree().current_scene.get_node("%TabContainer").find_node("LoginForm").get_index()



func _on_Create_pressed():
	var us_name = $"%Name".text
	us_email = $"%Email".text
	us_pass = $"%Pass".text
	var us_conf_pass = $"%ConPass".text
	if us_pass != us_conf_pass:
		NotificationServer.notify_warning("Passwords don't match.")
		return

	create_user_api(us_name, us_email, us_pass)

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func create_user_api(us_name, us_email, us_pass):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_create_user_api", [http_req])
	add_child(http_req)
	var dict = {"name": us_name, 'email': us_email, "password": us_pass}
	http_req.request(api_base + 'users/', PoolStringArray(["Content-Type: application/json"]), true, HTTPClient.METHOD_POST, to_json(dict))

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _create_user_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 201:
		print("Something went wrong")
		print(body.get_string_from_utf8())
		return
	http_req.queue_free()
# warning-ignore:unused_variable
	var json = parse_json(body.get_string_from_utf8())

	get_tree().current_scene.get_node("TabContainer").find_node("LoginForm").call_deferred("login", us_email, us_pass)


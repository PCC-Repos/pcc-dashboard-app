extends VBoxContainer

signal user_changed(user_id)
signal show_invite_user_modal(user_id)

const UserButton = preload("res://resources/free_agents/user.tscn")

var api_base

var headers
var user
var user_agent

func ready():
	fetch_users()
	$Agents/VBoxContainer.update()
	user_agent = user.agent_type
	match user_agent:
		"not_interested":
			$Invite.text = "Join as free agent"
		"free":
			$Invite.text = "Leave free agent"


func fetch_users():
	print("Fetching users")
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_fetch_users", [http_req])
	add_child(http_req)
	print(api_base + 'users/?agents=free')
	http_req.request(api_base + 'users/?agents=free')


func _fetch_users(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	for user in json:
		_create_user(user)
	$Agents/VBoxContainer.update()


func _create_user(user: Dictionary):
	var user_button = UserButton.instance()
	user_button.text = user["name"]
	user_button.name = str(user["id"])
	user_button.connect("mouse_pressed", self, "_show_popup_mouse", [user['id']])
	user_button.connect("long_tap", self, "_show_popup_touch", [user['id']])
	$Agents/VBoxContainer.add_child(user_button)


func _show_popup_mouse(button_index, user_id):
	match button_index:
		BUTTON_RIGHT:
			_show_popup(user_id)

func _show_popup_touch(_index, _long_tap_time, user_id):
	_show_popup(user_id)

func _show_popup(user_id):
	$CanvasLayer/UsersMenu.rect_position = get_global_mouse_position()
	$CanvasLayer/UsersMenu.popup()
	connect_if_disconnected($CanvasLayer/UsersMenu, "id_pressed", self, "_option_selected", [user_id])


func _option_selected(option_id, user_id):
	match option_id:
		0:
			# inviting
			emit_signal("show_invite_user_modal", user_id)
		# 1 is separator
		2:
			# copy id
			OS.clipboard = str(user_id)


func delete_user_api(user_id):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_delete_user_api", [http_req, str(user_id)])
	add_child(http_req)
	http_req.request(api_base + 'users/%s/' % user_id, PoolStringArray(), true, HTTPClient.METHOD_DELETE)


func _delete_user_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest, user_id: String):
	http_req.queue_free()
	_delete_user(user_id)


func _delete_user(user_id):
	find_node("*%s*" % user_id, true, false).queue_free()
	$Agents/VBoxContainer.update()


func _on_VBoxContainer_button_toggled(button_pressed, button):
	if button_pressed:
		emit_signal("user_changed", int(button.name))


func connect_if_disconnected(object: Object, signal_name, to_object, function_name, binds = [], flags = 0):
	if object.is_connected(signal_name, to_object, function_name):
		object.disconnect(signal_name, to_object, function_name)
	return object.connect(signal_name, to_object, function_name, binds, flags)



func refresh():  # ignore
	pass


func _on_Invite_pressed():
	print(user.agent_type)
	match user.agent_type:
		"free":
			edit_agent_api("not_interested")
		"not_interested":
			edit_agent_api("free")


func edit_agent_api(agent_type):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_join_agent_api", [http_req, str(user.id)])
	add_child(http_req)
	var dict = {
		"agent_type": agent_type
	}
	http_req.request(api_base + 'users/%s/' % user.id, PoolStringArray(["Content-Type: application/json"]) + headers, true, HTTPClient.METHOD_PATCH, to_json(dict))


func _join_agent_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest, user_id: String):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	match json.get("agent_type"):
		"free":
			_create_user(json)
			$Invite.text = "Leave free agents"
		"not_interested":
			_delete_user(json.id)
			$Invite.text = "Join as free agent"
	get_tree().call_group("admin_form", "refresh_main")

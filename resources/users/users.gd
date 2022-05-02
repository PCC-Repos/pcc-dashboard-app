extends VBoxContainer

signal user_changed(user_id)
signal show_create_user_modal()
signal show_edit_user_modal(user_id)

const UserButton = preload("res://resources/users/user.tscn")

var api_base

var headers
var user


func ready():
	fetch_users()


func fetch_users():
	print("Fetching users")
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_fetch_users", [http_req])
	add_child(http_req)
	print(api_base + 'users/')
	http_req.request(api_base + 'users/')


func _fetch_users(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	for user in json:
		_create_user(user)
	$Users/VBoxContainer.update()


func _create_user(user: Dictionary):
	var user_button = UserButton.instance()
	user_button.text = user["name"]
	user_button.name = str(user["id"])
	user_button.connect("mouse_pressed", self, "_show_popup_mouse", [user['id']])
	user_button.connect("long_tap", self, "_show_popup_touch", [user['id']])
	$Users/VBoxContainer.add_child(user_button)


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
			# editing
			emit_signal("show_edit_user_modal", user_id)
		1:
			# deleting
			delete_user_api(user_id)
		# 2 is separator 
		3:
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
	$Users/VBoxContainer.update()


func _create_user_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	_create_user(json)
	$Users/VBoxContainer.update()


func _on_VBoxContainer_button_toggled(button_pressed, button):
	if button_pressed:
		emit_signal("user_changed", int(button.name))


func _on_Create_pressed():
	emit_signal("show_create_user_modal")


func create_user_api(us_name):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_create_user_api", [http_req])
	add_child(http_req)
	var dict = {"name": us_name, 'discord_id': -1, 'guild_id': -1}
	http_req.request(api_base + 'users/', PoolStringArray(["Content-Type: application/json"]), true, HTTPClient.METHOD_POST, to_json(dict))


func edit_user_api(us_id, us_name):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_edit_user_api", [http_req, str(us_id)])
	add_child(http_req)
	var dict = {
		"name": us_name
	}
	http_req.request(api_base + 'users/%s/' % us_id, PoolStringArray(["Content-Type: application/json"]), true, HTTPClient.METHOD_PATCH, to_json(dict))


func _edit_user_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest, user_id: String):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	_edit_user(json)


func _edit_user(user: Dictionary):
	var user_button = find_node("*%s*" % user['id'], true, false)
	user_button.text = user["name"]


func _on_CreateUserModal_submit(us_name, us_reason):
	create_user_api(us_name)


func connect_if_disconnected(object: Object, signal_name, to_object, function_name, binds = [], flags = 0):
	if object.is_connected(signal_name, to_object, function_name):
		object.disconnect(signal_name, to_object, function_name)
	return object.connect(signal_name, to_object, function_name, binds, flags)



func _on_EditUserModal_submit(us_id, us_name, us_reason):
	edit_user_api(us_id, us_name)

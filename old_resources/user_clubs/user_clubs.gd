extends VBoxContainer

signal show_join_club_modal()

const UserClubButton = preload("res://old_resources/user_clubs/user_club.tscn")

var api_base
var current_user_id = -1

var headers
var user


func _on_Users_user_changed(user_id):
	print("Fetching clubs for specific user..")
	$UserClubs/VBoxContainer.hide()
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_fetch_clubs", [http_req])
	add_child(http_req)
	http_req.request(api_base + 'users/%s/clubs/' % user_id)
	current_user_id = user_id


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:shadowed_variable
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _fetch_clubs(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	clear_children($UserClubs/VBoxContainer)
	print("Response recieved, fetched clubs.")
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	for club in json:
		_create_club(club)
	$UserClubs/VBoxContainer.show()


func _on_JoinClubButton_pressed():
	emit_signal("show_join_club_modal")


func create_club_api(club_id):
	print("Creating user club..")
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_create_club_api", [http_req])
	add_child(http_req)
	var dict = {"club_id": club_id}
	http_req.request(api_base + 'users/%s/clubs/' % current_user_id, PoolStringArray(["Content-Type: application/json"]) + headers, true, HTTPClient.METHOD_POST, to_json(dict))


# warning-ignore:shadowed_variable
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _create_club_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	_create_club(json)


func _create_club(club: Dictionary):
	var club_btn = UserClubButton.instance()
	club_btn.text = club["name"]
	club_btn.name = str(club["id"])
	club_btn.hint_tooltip = club["description"]
	club_btn.connect("mouse_pressed", self, "_show_popup_mouse", [club['id']])
	club_btn.connect("long_tap", self, "_show_popup_touch", [club['id']])
	$UserClubs/VBoxContainer.add_child(club_btn)
	$UserClubs/VBoxContainer.update()


func _show_popup_mouse(button_index, club_id):
	match button_index:
		BUTTON_RIGHT:
			_show_popup(club_id)

func _show_popup_touch(index, long_tap_time, club_id):
	_show_popup(club_id)

func _show_popup(club_id):
	$CanvasLayer/UserClubsMenu.rect_position = get_global_mouse_position()
	$CanvasLayer/UserClubsMenu.popup()
	connect_if_disconnected($CanvasLayer/UserClubsMenu, "id_pressed", self, "_option_selected", [club_id])


func _option_selected(option_id, club_id):
	match option_id:
		0:
			# leaving
			delete_user_club_api(current_user_id, club_id)
		# 1 is seperator
		2:
			# copy id
			OS.clipboard = str(club_id)


func delete_user_club_api(user_id, club_id):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_delete_user_club_api", [http_req, str(club_id)])
	add_child(http_req)
	http_req.request(api_base + 'users/%s/clubs/%s/' % [user_id, club_id], headers, true, HTTPClient.METHOD_DELETE)


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:shadowed_variable
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _delete_user_club_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest, club_id: String):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	_delete_user_club(club_id)


func _delete_user_club(club_id):
	find_node("*%s*" % club_id, true, false).queue_free()
	

func _on_JoinClubModal_submit(club_id):
	create_club_api(club_id)


func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()


func connect_if_disconnected(object: Object, signal_name, to_object, function_name, binds = [], flags = 0):
	if object.is_connected(signal_name, to_object, function_name):
		object.disconnect(signal_name, to_object, function_name)
	return object.connect(signal_name, to_object, function_name, binds, flags)


func refresh():
	_on_Users_user_changed(current_user_id)

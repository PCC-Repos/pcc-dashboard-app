extends VBoxContainer

signal show_add_member_modal()

const MemberButton = preload("res://resources/members/member.tscn")

var api_base

var headers
var user

var current_club_id = -1


func _on_Clubs_club_changed(club_id):
	$Members/VBoxContainer.hide()
	fetch_members(club_id)


func fetch_members(club_id: int):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_fetch_members", [http_req])
	add_child(http_req)
	http_req.request(api_base + 'clubs/%s/members/' % club_id)
	current_club_id = club_id


func _fetch_members(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	clear_children($Members/VBoxContainer)
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	for member in json:
		_create_member(member)
	$Members/VBoxContainer.show()


func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()


func _create_member(member: Dictionary):
	var member_button = MemberButton.instance()
	member_button.text = member["nick"] if member["nick"] else member['user']["name"]
	member_button.name = str(member['user']["id"])
	member_button.hint_tooltip = member['user']["name"]
	member_button.connect("mouse_pressed", self, "_show_popup_mouse", [member['user']['id']])
	member_button.connect("long_tap", self, "_show_popup_touch", [member['user']['id']])
	$Members/VBoxContainer.add_child(member_button)


func _show_popup_mouse(button_index, user_id):
	match button_index:
		BUTTON_RIGHT:
			_show_popup(user_id)


func _show_popup_touch(_index, _long_tap_time, user_id):
	_show_popup(user_id)


func _show_popup(user_id):
	$CanvasLayer/MembersMenu.rect_position = get_global_mouse_position()
	$CanvasLayer/MembersMenu.popup()
	connect_if_disconnected($CanvasLayer/MembersMenu, "id_pressed", self, "_option_selected", [user_id])


func _option_selected(option_id, user_id):
	match option_id:
		0:
			# editing
			pass
		1:
			# kicking/deleting
			delete_member_api(current_club_id, user_id)
		
		# 2 is seperator
		3:
			# copy id
			OS.clipboard = str(user_id)


func _on_Add_pressed():
	emit_signal("show_add_member_modal")


func delete_member_api(club_id, user_id):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_delete_member_api", [http_req, str(user_id)])
	add_child(http_req)
	http_req.request(api_base + 'clubs/%s/members/%s/' % [club_id, user_id], PoolStringArray(), true, HTTPClient.METHOD_DELETE)


func _delete_member_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest, user_id: String):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	_delete_member(user_id)


func _delete_member(user_id):
	find_node("*%s*" % user_id, true, false).queue_free()


func _create_member_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	_create_member(json)


func create_member_api(user_id):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_create_member_api", [http_req])
	add_child(http_req)
	var dict = {"user_id": user_id}
	http_req.request(api_base + 'clubs/%s/members/' % current_club_id, PoolStringArray(["Content-Type: application/json"]), true, HTTPClient.METHOD_POST, to_json(dict))


func _on_AddMemberModal_submit(user_id, reason):
	create_member_api(user_id)


func connect_if_disconnected(object: Object, signal_name, to_object, function_name, binds = [], flags = 0):
	if object.is_connected(signal_name, to_object, function_name):
		object.disconnect(signal_name, to_object, function_name)
	return object.connect(signal_name, to_object, function_name, binds, flags)

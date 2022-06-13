extends VBoxContainer

signal club_changed(club_id)
signal show_create_club_modal()
signal show_edit_club_modal(club_id)

var api_base

var headers
var user

const ClubButton = preload("res://resources/clubs/club.tscn")


func ready():
	fetch_clubs()

func _fetch_clubs(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	print("Response recieved, fetched clubs.")
	http_req.queue_free()
	var json = parse_json(body.get_string_from_utf8())
	print(json)
	for club in json:
		_create_club(club)


func fetch_clubs():
	print("Fetching clubs..")
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_fetch_clubs", [http_req])
	add_child(http_req)
	http_req.request(api_base + 'clubs/')


func _on_VBoxContainer_button_toggled(button_pressed, button):
	if button_pressed:
		print("Club changed")
		emit_signal("club_changed", int(button.name))


func _on_CreateNewButton_pressed():
	emit_signal("show_create_club_modal")


func create_club_api(club_name, club_description, club_public):
	print("Creating club..")
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_create_club_api", [http_req])
	add_child(http_req)
	var dict = {"name": club_name, "description": club_description, "public": club_public}
	http_req.request(api_base + 'clubs/', PoolStringArray(["Content-Type: application/json"]) + headers, true, HTTPClient.METHOD_POST, to_json(dict))


func _create_club_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
		if parse_json(body.get_string_from_utf8()).detail == "Club can only be created by admins.":
			NotificationServer.push_notification(NotificationServer.ERROR, "Sorry! You are not an Admin. Can't create a club!")
		return
	http_req.queue_free()
	_create_club(parse_json(body.get_string_from_utf8()))


func _create_club(club: Dictionary):
	var club_btn = ClubButton.instance()
	club_btn.text = club["name"]
	club_btn.name = str(club["id"])
	club_btn.hint_tooltip = club["description"]
	club_btn.connect("mouse_pressed", self, "_show_popup_mouse", [club["id"]])
	club_btn.connect("long_tap", self, "_show_popup_touch", [club["id"]])
	$Clubs/VBoxContainer.add_child(club_btn)
	$Clubs/VBoxContainer.update()
	print("club created")


func _show_popup_mouse(button_index, club_id):
	match button_index:
		BUTTON_RIGHT:
			_show_popup(club_id)

func _show_popup(club_id):
	$CanvasLayer/ClubsMenu.rect_position = get_global_mouse_position()
	$CanvasLayer/ClubsMenu.popup()
	connect_if_disconnected($CanvasLayer/ClubsMenu, "id_pressed", self, "_option_selected", [club_id])

func _show_popup_touch(_index, _long_tap_time, club_id):
	_show_popup(club_id)

func _on_CreateClubModal_submit(club_name, club_description, club_public):
	create_club_api(club_name, club_description, club_public)


func _edit_club(club: Dictionary):
	var club_btn = find_node("*%s*" % str(club["id"]), true, false)
	club_btn.text = club["name"]
	club_btn.hint_tooltip = club["description"]
	$Clubs/VBoxContainer.update()


func edit_club_api(club_id, club_name, club_description, _club_money):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_edit_club_api", [http_req, str(club_id)])
	add_child(http_req)
	var dict = {
		"name": club_name,
		"description": club_description
	}
	http_req.request(api_base + 'clubs/%s/' % club_id, PoolStringArray(["Content-Type: application/json"]) + headers, true, HTTPClient.METHOD_PATCH, to_json(dict))


func _edit_club_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest, club_id: String):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	var json = parse_json(body.get_string_from_utf8())
	_edit_club(json)
	http_req.queue_free()


func delete_club_api(club_id):
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_delete_club_api", [http_req, str(club_id)])
	add_child(http_req)
	http_req.request(api_base + 'clubs/%s/' % club_id, headers, true, HTTPClient.METHOD_DELETE)


func _delete_club_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest, club_id: String):
	if response_code != 200:
		print("Something went wrong")
		print(body.get_string_from_utf8())
	http_req.queue_free()
	_delete_club(club_id)


func _delete_club(club_id):
	find_node("*%s*" % str(club_id), true, false).queue_free()
	$Clubs/VBoxContainer.update()


func _option_selected(option_id, club_id):
	match option_id:
		0:
			# editing, won't be implemented for now
			emit_signal("show_edit_club_modal", club_id)
		1:
			# deleting
			delete_club_api(club_id)
		# 2 is seperator
		3:
			# copy id
			OS.clipboard = str(club_id)


func connect_if_disconnected(object: Object, signal_name, to_object, function_name, binds = [], flags = 0):
	if object.is_connected(signal_name, to_object, function_name):
		object.disconnect(signal_name, to_object, function_name)
	return object.connect(signal_name, to_object, function_name, binds, flags)


func _on_EditClubModal_submit(club_id, club_name, club_description):
	edit_club_api(club_id, club_name, club_description, 0)



func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()

func refresh():
	clear_children($Clubs/VBoxContainer)
	fetch_clubs()

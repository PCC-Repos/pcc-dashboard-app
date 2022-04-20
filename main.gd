extends Control

const API_BASE = "http://api.proclubsfederation.com/api/v1/"
const DebugAPI_BASE = "http://127.0.0.1:8000/api/latest/"

var api_base
var debug = false

func _ready():
	if OS.has_feature('debug') and debug:
		api_base = DebugAPI_BASE
	else:
		api_base = API_BASE
	prints("Using API base", api_base)
	get_tree().set_group("api_base", "api_base", api_base)
	get_tree().call_group("api_base", "ready")
	$AudioStreamRandomPlayer.play()

func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			print("Quit request")
			get_tree().change_scene("res://closing_screen/closing_screen.tscn")

#func _ready():
#	var http_req = HTTPRequest.new()
#	http_req.connect("request_completed", self, "_request_completed", [http_req])
#	add_child(http_req)
#	http_req.request(API_BASE + 'clubs/')
#
#func _request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
#	var json = parse_json(body.get_string_from_utf8())
#	for club in json["clubs"]:
#		var button = Button.new()
#		button.text = club["name"]
#		button.name = club["id"]
#		button.size_flags_horizontal = SIZE_EXPAND_FILL
#		button.button_mask = BUTTON_MASK_RIGHT
#		button.hint_tooltip = club["description"]
#		get_child(0).add_child(button)
#		button.connect("pressed", self, "_show_popup_menu", [club["id"]])
#		for member in club["members"]:
#			http_req.disconnect("request_completed", self, "_request_completed")
#			print(member["id"])
#			http_req.request(API_BASE + ('users/%s' % int(member["id"])))
##			print(yield(http_req, "request_completed")[3].get_string_from_utf8())
#			var user = parse_json(yield(http_req, "request_completed")[3].get_string_from_utf8())
##			print(user)
#			var member_button = Button.new()
#			member_button.text = member["nick"] if member["nick"] else user["name"]
#			member_button.name = member["id"]
#			member_button.size_flags_horizontal = SIZE_EXPAND_FILL
#			$"../../VBoxContainer2/ScrollContainer/VBoxContainer".add_child(member_button)
#	http_req.queue_free()
#
#func _on_CreateNewButton_pressed():
#	$"../../../../../WindowDialog".popup_centered()
#
#func _request_completed_post(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
#	var json = parse_json(body.get_string_from_utf8())
#	var button = Button.new()
#	button.text = json["club"]["name"]
#	button.name = json["club"]["id"]
#	button.hint_tooltip = json["club"]["description"]	
#	button.size_flags_horizontal = SIZE_EXPAND_FILL
#	button.button_mask = BUTTON_MASK_RIGHT
#	button.connect("pressed", self, "_show_popup_menu", [json["club"]["id"]])
#	get_child(0).add_child(button)
#	http_req.queue_free()
#
#func _button_pressed(id):
#	var http_req = HTTPRequest.new()
#	http_req.connect("request_completed", self, "_request_completed_delete", [http_req])
#	add_child(http_req)
#	http_req.request(API_BASE + ('clubs/%s' % int(id)), PoolStringArray(), true, HTTPClient.METHOD_DELETE)
#	find_node("*"+id+"*", true, false).queue_free()
#
#func _show_popup_menu(id):
#	$"../../../../../PopupMenu".rect_position = get_global_mouse_position()
#	$"../../../../../PopupMenu".popup()
#	if $"../../../../../PopupMenu".is_connected("id_pressed", self, "_on_PopupMenu_id_pressed"):
#		$"../../../../../PopupMenu".disconnect("id_pressed", self, "_on_PopupMenu_id_pressed")
#	$"../../../../../PopupMenu".connect("id_pressed", self, "_on_PopupMenu_id_pressed", [id])
#
#
#func _request_completed_delete(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
#	http_req.queue_free()
#
#func _on_Create_pressed():
#	var http_req = HTTPRequest.new()
#	http_req.connect("request_completed", self, "_request_completed_post", [http_req])
#	add_child(http_req)
#	var dict = {"name": $"../../../../../WindowDialog/MarginContainer/VBoxContainer/HBoxContainer/LineEdit".text, "description": $"../../../../../WindowDialog/MarginContainer/VBoxContainer/HBoxContainer2/LineEdit".text, "guild_id": -1}
#	http_req.request(API_BASE + 'clubs/', PoolStringArray(["Content-Type: application/json"]), true, HTTPClient.METHOD_POST, to_json(dict))
#	$"../../../../../WindowDialog".hide()
#
#
#func _on_InviteMember_pressed():
#	$"../../../../../WindowDialog2".popup_centered()
#
#
#func _on_Invite_pressed():
#	$"../../../../../WindowDialog2/MarginContainer/VBoxContainer/HBoxContainer/LineEdit".text
#
#
#func _on_PopupMenu_id_pressed(id, club_id):
#	match id:
#		1:
#			# delete
#			_button_pressed(club_id)

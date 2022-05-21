extends Control

var user
var logged_in
var headers
var api_base

onready var account_btn = $VBoxContainer/Header/PanelContainer/MarginContainer/HBoxContainer/AccountButton

func ready():
	$AudioStreamRandomPlayer.play()
	account_btn.text = user.name
	account_btn.get_popup().connect("id_pressed", self, "_id_pressed")

func _id_pressed(id):
	match id:
		2:
			print("logging out")
			logout()
		0:
			print("refreshing")
			refresh_main()

func logout():
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_request_completed", [http_req])
	add_child(http_req)
	http_req.request(api_base + "auth/revoke/", headers, true, HTTPClient.METHOD_POST)

func _request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req: HTTPRequest):
	http_req.queue_free()
	if response_code != 200:
		prints(response_code, "Something went terribly wrong when trying to signout.")
		return
	
	get_tree().call_group("main", "logged_out")

func refresh_main():
	print("refresh")
	get_tree().call_group("login_ready", "refresh")
	get_tree().call_group("main", "refresh")

func refresh(): # do nothing
	pass

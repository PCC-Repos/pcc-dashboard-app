extends Control

var user
var logged_in
var headers
var api_base

onready var account_btn = $"%AccountButton"
onready var http: = $HTTPRequest

func ready():
	$AudioStreamRandomPlayer.play()
	account_btn.text = user.name
	account_btn.get_popup().connect("id_pressed", self, "_id_pressed")
	$"%TabContainer".set_tab_icon(0, load("res://assets/images/UI/Clubs.svg"))


	$"%WheelButtons".buttons = {}
	for child_index in $"%TabContainer".get_child_count():
		$"%WheelButtons".buttons[$"%TabContainer".get_child(child_index).name] = preload("res://assets/images/PCF_Logo.png")
	yield(get_tree(), "idle_frame")
	$"%WheelButtons"._ready()

#	($"%Clubs" as Button).group.connect("pressed", self, "_button_pressed")


func _id_pressed(id):
	match id:
		2:
			print("logging out")
			logout()
		0:
			print("refreshing")
			refresh_main()

func logout():
	http.request(api_base + "auth/revoke/", headers, true, HTTPClient.METHOD_POST)

func _request_completed(_result: int, response_code: int, _headers: PoolStringArray, _body: PoolByteArray):
	http.queue_free()
	if response_code != 200:
		print_debug(response_code, " Something went wrong when trying to signout.")
		get_tree().current_scene.notif.set_text("Could not Log Out.\nSomething went wrong!", get_tree().current_scene.notif.Type.Error)
		return

	get_tree().call_group("main", "logged_out")

func refresh_main():
	print("refresh")
	get_tree().call_group("login_ready", "refresh")
	get_tree().call_group("main", "refresh")

func refresh(): # do nothing
	pass

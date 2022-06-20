extends Control

var user
var logged_in
var headers
var api_base

onready var account_btn = $"%AccountButton"
onready var dialogs = $NextGenDialogs
onready var http: = $HTTPRequest
enum {
	USER = 1,
	MANAGER = 2,
	ADMIN = 4,
	PREMIUM_USER = 8,
	CO_MANAGER = 16
}

func ready():
	$AudioStreamRandomPlayer.play()
	user = GlobalUserState.user
	match GlobalUserState.permissions:
		USER:
			$"%Admin".hide()
			$"%Marketplace".hide()
		MANAGER:
			$"%Admin".hide()
	account_btn.text = user.name
	account_btn.get_popup().connect("index_pressed", self, "AccountButton_popup_index_pressed")
	NotificationServer.notify_info("Logged in as %s" % user.name)

#	$"%WheelButtons".buttons = {}
#	for child_index in $"%TabContainer".get_child_count():
#		$"%WheelButtons".buttons[$"%TabContainer".get_child(child_index).name] = preload("res://assets/images/PCF_Logo.png")
#	yield(get_tree(), "idle_frame")
#	$"%WheelButtons"._ready()


func AccountButton_popup_index_pressed(index: int):
	var item: String = account_btn.get_popup().get_item_text(index)
	match item:
		"Refresh":
			print("refreshing")
			refresh_main()
		"Settings":
			dialogs.get_node("SettingsDialog").popup()
		"Log Out":
			print("logging out")
			GlobalUserState.logout()

func logout():
	http.request(api_base + "auth/revoke/", headers, true, HTTPClient.METHOD_POST)

func _request_completed(_result: int, response_code: int, _headers: PoolStringArray, _body: PoolByteArray):
	if response_code != 204:
		print_debug(response_code, " Something went wrong when trying to signout.")
		NotificationServer.notify_critical("Could not Log Out.\nSomething went wrong!")
		return

#	get_tree().call_group("main", "logged_out")

func refresh_main():
	print("refresh")
	get_tree().call_group("login_ready", "refresh")
	get_tree().call_group("main", "refresh")

func refresh(): # do nothing
	pass

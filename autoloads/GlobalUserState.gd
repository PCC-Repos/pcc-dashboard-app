extends Node

signal logged_in
signal login_failed
signal logged_out

var token_file = "user://login/token.txt"
var user: User
var log_in = false
var login_failed = false
var client: PCFClient
var permissions: int

func _ready():
	client = PCFClient.new()
	add_child(client)
	var token = get_access_token()
	if token:
		var auth_token = Token.new().from_json({
			"access_token": token
		})
		client.set_token(auth_token)
		var output = yield(try_load_user(false), "completed")
		if not output:
			print_debug("Invalid access token, loading login screen.")
			emit_signal("login_failed")
			login_failed = true
		else:
			print_debug("Login successful! Starting WebSocket!")
			client.get_ws_client().init()
			emit_signal("logged_in")

func get_access_token():
	var file = File.new()
	var directory = Directory.new()
	if file.file_exists(token_file):
		if file.open_encrypted_with_pass(token_file, File.READ, "pcf_dashboard") == OK:
			var token = file.get_as_text()
			print_debug("Loading Token...")
			file.close()
			return token
	else:
		directory.make_dir_recursive(token_file.get_base_dir())

func save_access_token(res: Token):
	var file = File.new()
	if file.open_encrypted_with_pass(token_file, File.WRITE, "pcf_dashboard") == OK:
		file.store_string(res["access_token"])
		print_debug("Saving Token...")
		file.close()

func login(us_email, us_password):
	print("Logging In...")
	var auth_params = AuthorizeParams.new()
	auth_params.email_id = us_email
	auth_params.password = us_password
	var token = yield(client.get_rest_client().authorize(auth_params), "completed")
	if token is HTTPResponse and token.is_error():
		print_debug("There's something broken...")
		match_error(token)
		return
	client.set_token(token)
	save_access_token(token)
	if yield(try_load_user(), "completed"):
		print("logging in")
		emit_signal("logged_in")


func logout():
	yield(client.get_rest_client().revoke(), "completed")
	emit_signal("logged_out")

func match_error(res: HTTPResponse):
	if res.is_not_found_error():
		NotificationServer.notify_error("Not found.")
	elif res.is_unauthorized_error():
		NotificationServer.notify_critical("Failed to Login.\nPlease check that you entered the details correctly or create a New Account.")

func try_load_user(show_notifications = true):
	var res = yield(client.get_rest_client().get_current_user(), "completed")
	if res is HTTPResponse and res.is_error():
		print_debug("Error, maybe unauthorized?", " Error: ", res.response_code)
		if show_notifications:
			NotificationServer.notify_critical("Some error occured!")
	else:
		user = res
		log_in = true
		print_debug("Loaded User, logged in!")
		res = yield(client.get_rest_client().get_permissions(str(user.id)), "completed")
		if res is HTTPResponse and res.is_error():
			print_debug("Unable to load permissons!", " Error: ", res.response_code)
			if show_notifications:
				if res.response_code == 0:
					NotificationServer.notify_error("No Internet!\nCheck your Internet Connection then try again.")
				else:
					NotificationServer.notify_error("Unable to load permissions!")
		else:
			permissions = res.permissions
			return true
	return false

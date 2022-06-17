extends Node

signal logged_in
signal logged_out

var token_file = "user://login/token.txt"
var user: User
var logged_in = false
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
		if not try_load_user():
			print_debug("Invalid access token, loading login screen.")

func get_access_token():
	var file = File.new()
	var directory = Directory.new()
	if file.file_exists(token_file):
		if file.open_encrypted_with_pass(token_file, File.READ, "pcf_dashboard") == OK:
			var token = file.get_as_text()
			print("token loading")
			file.close()
			return token
	else:
		directory.make_dir_recursive(token_file.get_base_dir())

func save_access_token(res: Token):
	var file = File.new()
	if file.open_encrypted_with_pass(token_file, File.WRITE, "pcf_dashboard") == OK:
		file.store_string(res["access_token"])
		print("token saving")
		file.close()

func login(us_email, us_password):
	var auth_params = AuthorizeParams.new()
	auth_params.email_id = us_email
	auth_params.password = us_password
	var token = yield(client.get_rest_client().authorize(auth_params), "completed")
	if token is HTTPResponse and token.is_error():
		match_error(token)
		return
	client.set_token(token)
	save_access_token(token)
	if try_load_user():
		emit_signal("logged_in")


func logout():
	yield(client.get_rest_client().revoke(), "completed")
	emit_signal("logged_out")

func match_error(res: HTTPResponse):
	if res.is_not_found_error():
		NotificationServer.notify_error("Not found.")
	elif res.is_unauthorized_error():
		NotificationServer.notify_critical("Failed to Login.\nPlease check that you entered the details correctly or create a New Account.")

func try_load_user():
	var res = yield(client.get_rest_client().get_current_user(), "completed")
	if res is HTTPResponse and res.is_error():
		NotificationServer.notify_critical("Something terribly went wrong while trying to fetch user.")
	else:
		user = res
		logged_in = true
		print_debug("Loaded User, logged in!")
		res = yield(GlobalUserState.client.get_rest_client().get_permissions(str(user.id)), "completed")
		if res is HTTPResponse and res.is_error():
			NotificationServer.notify_critical("Unable to fetch permissions.")
		else:
			permissions = res.permissions
			return true
	return false

extends Node

signal logged_in
signal login_failed
signal logged_out

var TOKEN_FILEPATH = "user://login/token.dat"
var user: User
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
			print("Invalid access token, loading login screen.")
			emit_signal("login_failed")
			login_failed = true
		else:
			print("Login successful! Starting WebSocket!")
			client.get_ws_client().init()
			emit_signal("logged_in")

func get_access_token():
	var file = File.new()
	var directory = Directory.new()

	if not file.file_exists(TOKEN_FILEPATH):
		directory.make_dir_recursive(TOKEN_FILEPATH.get_base_dir())
		return null

	var err = file.open_encrypted_with_pass(TOKEN_FILEPATH, File.READ, "PcF_d@$hb0ard!")
	if err == ERR_FILE_CORRUPT:
		directory.remove(TOKEN_FILEPATH)
		return null
	elif err == OK:
		var token = file.get_as_text()
		print("Loading Access Token from file...")
		file.close()
		return token

func save_access_token(res: Token):
	var file = File.new()
	if file.open_encrypted_with_pass(TOKEN_FILEPATH, File.WRITE, "PcF_d@$hb0ard!") == OK:
		file.store_string(res.access_token)
		print("Saving Token...")
		file.close()


# -----------------
# ----- Login -----
# -----------------
func login(p_email: String, p_password: String) -> bool:
	print("Store:: Logging In...")

	var auth_params = AuthorizeParams.new()
	auth_params.email_id = p_email
	auth_params.password = p_password

	var token = yield(API.rest.authorize(auth_params), "completed")
	if token is HTTPResponse and token.is_error():
		print("Store::login:: Got error: ", token)
		match_login_error(token)
		return false

	print(token)
	API.client.set_token(token)
	return true
	#save_access_token(token)
#	if yield(try_load_user(), "completed"):
#		print("logging in")
#		emit_signal("logged_in")


func logout():
	yield(API.rest.revoke(), "completed")
	emit_signal("logged_out")


func match_login_error(err: HTTPResponse):
	if err.is_not_found_error():
		NotificationServer.notify_error("Not found.")
	elif err.is_unauthorized_error():
		NotificationServer.notify_critical("Failed to Login.\nPlease check that you entered the details correctly or create a New Account.")
	elif err.is_validation_error():
		NotificationServer.notify_critical("Enter a valid email address.")

func try_load_user(show_notifications = true) -> bool:
	user = null
	var res = yield(API.rest.get_current_user(), "completed")
	if res is HTTPResponse and res.is_error():
		print("Store::try_load_user: ", res)
		if show_notifications:
			NotificationServer.notify_critical("Some error occured!")
		return false

	user = res
	print("Loaded User!")

	res = yield(API.rest.get_permissions(user.id), "completed")
	if res is HTTPResponse and res.is_error():
		print("Store::try_load_user: ", res)
		if show_notifications:
			if res.response_code == 0:
				NotificationServer.notify_error("No Internet!\nCheck your Internet Connection then try again.")
			else:
				NotificationServer.notify_error("Unable to load permissions!")
		return false
	else:
		permissions = res.permissions
		return true

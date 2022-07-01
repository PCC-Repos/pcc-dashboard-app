extends Node

signal logged_in
signal login_failed
signal logged_out

var TOKEN_FILEPATH = "user://login/token.dat"
var user: User
var login_failed = false
var permissions: int
var main_screen_tab_controller
var admin_scene

enum UserPermissionsEnum {
	USER = 1,
	MANAGER = 2,
	ADMIN = 4,
	PREMIUM_USER = 8,
	CO_MANAGER = 16
}

func get_access_token():
	var file = File.new()
	var directory = Directory.new()

	if not file.file_exists(TOKEN_FILEPATH):
		directory.make_dir_recursive(TOKEN_FILEPATH.get_base_dir())
		return null

	L.print("Store", "Loading access token from file...")
	var err = file.open_encrypted_with_pass(TOKEN_FILEPATH, File.READ, "PcF_d@$hb0ard!")
	if err == ERR_FILE_CORRUPT:
		directory.remove(TOKEN_FILEPATH)
		return null
	elif err == OK:
		var token = file.get_as_text()
		file.close()
		return token


func save_access_token(access_token: String):
	var file = File.new()
	if file.open_encrypted_with_pass(TOKEN_FILEPATH, File.WRITE, "PcF_d@$hb0ard!") == OK:
		file.store_string(access_token)
		L.print("Store", "Saving access token to file...")
		file.close()

func delete_access_token() -> void:
	var dir = Directory.new()
	if not dir.file_exists(TOKEN_FILEPATH):
		return
	dir.remove(TOKEN_FILEPATH)


# -----------------
# ----- Login -----
# -----------------
func login(p_email: String, p_password: String) -> bool:
	var auth_params = AuthorizeParams.new()
	auth_params.email_id = p_email
	auth_params.password = p_password

	var token = yield(API.rest.authorize(auth_params), "completed")
	if token is HTTPResponse and token.is_error():
		L.debug("Store", "login", "error", token)
		match_login_error(token)
		return false

	API.client.set_token(token)
	save_access_token(token.access_token)

	var res = yield(try_load_user(), "completed")
	if not res:
		emit_signal("login_failed")
	else:
		emit_signal("logged_in")
	return true


func logout():
	yield(API.rest.revoke(), "completed")
	delete_access_token()
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
		L.debug("Store", "try_load_user", res)
		if show_notifications:
			NotificationServer.notify_critical("Some error occured!")
		return false

	user = res

	res = yield(API.rest.get_permissions(user.id), "completed")
	if res is HTTPResponse and res.is_error():
		if show_notifications:
			if res.response_code == 0:
				NotificationServer.notify_error("No Internet!\nCheck your Internet Connection then try again.")
			else:
				NotificationServer.notify_error("Unable to load permissions!")
		return false
	else:
		permissions = res.permissions
		return true


func try_autologin():
	var access_token = get_access_token()

	if not access_token:
		return

	NotificationServer.notify_info("Auto logging in...")

	var auth_token = Token.new()
	auth_token.access_token = access_token
	API.client.set_token(auth_token)

	var res = yield(try_load_user(false), "completed")
	if not res:
		emit_signal("login_failed")
	else:
		#TODO: Uncomment this to connect to WS
		#API.ws.init()
		emit_signal("logged_in")


func get_user_permission_as_string() -> String:
	if not permissions: return ""
	return UserPermissionsEnum.keys()[UserPermissionsEnum.values().find(permissions)]

func is_self_admin(): return permissions == UserPermissionsEnum.ADMIN
func is_self_manager(): return permissions == UserPermissionsEnum.MANAGER
func is_self_user(): return permissions == UserPermissionsEnum.USER
func is_self_premium_user(): return permissions == UserPermissionsEnum.PREMIUM_USER
func is_self_co_manager(): return permissions == UserPermissionsEnum.CO_MANAGER

extends Control

onready var register_btn = $VB/RegisterBtn
onready var back_btn = $VB/BackBtn
onready var name_field: Field = $VB/SC/MC/VB/Name
onready var email_field: Field = $VB/SC/MC/VB/Email
onready var pass_field: Field = $VB/SC/MC/VB/Pass
onready var confirm_pass_field: Field = $VB/SC/MC/VB/ConfirmPass


func _ready() -> void:
	register_btn.connect("pressed", self, "_on_register_btn_pressed")
	back_btn.connect("pressed", self, "_on_back_btn_pressed")

func _on_back_btn_pressed() -> void:
	Store.main_screen_tab_controller.show_form("login")

func _on_register_btn_pressed() -> void:
	if name_field.get_text() == "":
		return NotificationServer.notify_warning("Enter an avatar name")
	if email_field.get_text() == "":
		return NotificationServer.notify_warning("Enter an email")
	if pass_field.get_text() == "":
		return NotificationServer.notify_warning("Enter a password")

	if pass_field.get_text() != confirm_pass_field.get_text():
		NotificationServer.notify_warning("Passwords don't match.")
		return

	var create_user_params = CreateUserParams.new()
	create_user_params.name = name_field.get_text()
	create_user_params.email = email_field.get_text()
	create_user_params.password = pass_field.get_text()
	create_user_params.agent_type = "free"

	register_btn.disabled = true
	NotificationServer.notify_info("Registering...")
	var user = yield(API.rest.create_user(create_user_params), "completed")
	if user is HTTPResponse and user.is_error():
		L.debug("RegisterForm", "_on_register_btn_pressed", "error", user)
		NotificationServer.notify_error("Enter a valid email")
		register_btn.disabled = false
		return

	NotificationServer.notify_info("Logging in...")
	var res = yield(Store.login(create_user_params.email, create_user_params.password), "completed")
	register_btn.disabled = false

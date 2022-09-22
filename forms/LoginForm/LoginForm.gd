extends Control

onready var email_field: Field = $VB/Email
onready var password_field: Field = $VB/Password
onready var login_btn = $VB/HB/LoginBtn
onready var register_btn = $VB/RegisterBtn

func _ready():
	var _c
	_c = register_btn.connect("pressed", self, "_on_register_btn_pessed")
	_c = login_btn.connect("pressed", self, "_on_login_btn_pressed")

func _on_login_btn_pressed():
	var email = email_field.get_text()
	var password = password_field.get_text()

	if email == "":
		return NotificationServer.notify_warning("Enter an email")
	if password == "":
		return NotificationServer.notify_warning("Enter a password")

	login_btn.disabled = true
	NotificationServer.notify_info("Logging in...")
	var success = yield(Store.login(email, password), "completed")
	if success:
		email_field.set_text("")
	login_btn.disabled = false

func _on_register_btn_pessed():
	Store.main_screen_tab_controller.show_form("register")


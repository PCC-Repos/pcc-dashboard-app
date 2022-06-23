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
	var success = yield(Store.login(email, password), "completed")
	if not success:
		login_btn.disabled = false

func _on_register_btn_pessed():
#	get_tree().current_scene.get_node("%TabContainer").current_tab = get_tree().current_scene.get_node("%TabContainer").find_node("RegisterForm").get_index()
	pass


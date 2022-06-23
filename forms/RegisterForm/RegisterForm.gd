extends Control

onready var register_btn = $VB/RegisterBtn
onready var name_field: Field = $VB/SC/MC/VB/Name
onready var email_field: Field = $VB/SC/MC/VB/Email
onready var pass_field: Field = $VB/SC/MC/VB/Pass
onready var confirm_pass_field: Field = $VB/SC/MC/VB/ConfirmPass


func _ready() -> void:
	#get_tree().current_scene.get_node("AnimationPlayer").play("LightsON")
	register_btn.connect("pressed", self, "_on_register_btn_pressed")

#func _on_BackButton_pressed() -> void:
#	get_tree().current_scene.get_node("%TabContainer").current_tab = get_tree().current_scene.get_node("%TabContainer").find_node("LoginForm").get_index()

func _on_register_btn_pressed():
	if pass_field.get_text() != confirm_pass_field.get_text():
		NotificationServer.notify_warning("Passwords don't match.")
		return

	var create_user_params = CreateUserParams.new()
	create_user_params.name = name_field.get_text()
	create_user_params.email = email_field.get_text()
	create_user_params.password = pass_field.get_text()
	create_user_params.agent_type = "free"

	var user = yield(API.rest.create_user(create_user_params), "completed")

extends TabContainer

onready var login_form = $LoginForm
onready var register_form = $RegisterForm

func show_form(p_which: String):
	login_form.visible = false
	register_form.visible = false

	match p_which.to_lower():
		"login":
			login_form.visible = true
		"register":
			register_form.visible = true

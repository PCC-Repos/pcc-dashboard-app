extends WindowDialog

signal submit(us_name, us_email, us_password)


func _on_Create_pressed():
	var us_name = $MarginContainer/VBoxContainer/Name/LineEdit.text
	var us_email = $MarginContainer/VBoxContainer/Email/LineEdit.text
	var us_pass = $MarginContainer/VBoxContainer/Password/LineEdit.text
	var us_conf_pass = $MarginContainer/VBoxContainer/ConfirmPassword/LineEdit.text
	if us_pass == us_conf_pass:
		print(us_conf_pass, us_pass)
		print("Not matched!!!")
	emit_signal("submit", us_name, us_email, us_pass)
	$MarginContainer/VBoxContainer/Name/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Email/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Password/LineEdit.text = ""
	$MarginContainer/VBoxContainer/ConfirmPassword/LineEdit.text = ""
	hide()


func _on_LoginForm_show_register_modal():
	popup_centered()

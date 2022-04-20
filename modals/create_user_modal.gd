extends WindowDialog

signal submit(us_name, us_reason)

func _on_Create_pressed():
	var us_name = $MarginContainer/VBoxContainer/Name/LineEdit.text
	var us_reason = $MarginContainer/VBoxContainer/Reason/LineEdit.text
	emit_signal("submit", us_name, us_reason)
	$MarginContainer/VBoxContainer/Name/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Reason/LineEdit.text = ""
	hide()


func _on_Users_show_create_user_modal():
	popup_centered()

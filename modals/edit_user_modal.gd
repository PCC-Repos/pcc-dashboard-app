extends WindowDialog

signal submit(us_name, us_reason)

var us_id


func _on_Save_pressed():
	var us_name = $MarginContainer/VBoxContainer/Name/LineEdit.text
	var us_reason = $MarginContainer/VBoxContainer/Reason/LineEdit.text
	emit_signal("submit", us_id, us_name, us_reason)
	$MarginContainer/VBoxContainer/Name/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Reason/LineEdit.text = ""
	hide()


func _on_Users_show_edit_user_modal(_us_id):
	us_id = _us_id
	popup_centered()

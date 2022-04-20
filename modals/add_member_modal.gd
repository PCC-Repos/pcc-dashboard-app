extends WindowDialog

signal submit(user_id, reason)

func _on_Members_show_add_member_modal():
	popup_centered()

func _on_Add_pressed():
	var us_id = $MarginContainer/VBoxContainer/ID/LineEdit.text
	var us_reason = $MarginContainer/VBoxContainer/Reason/LineEdit.text
	emit_signal("submit", us_id, us_reason)
	hide()
	$MarginContainer/VBoxContainer/ID/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Reason/LineEdit.text = ""

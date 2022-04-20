extends WindowDialog

signal submit(club_id)



func _on_Join_pressed():
	var club_id = $MarginContainer/VBoxContainer/ID/LineEdit.text
	emit_signal("submit", club_id)
	$MarginContainer/VBoxContainer/ID/LineEdit.text = ""
	hide()


func _on_UserClubs_show_join_club_modal():
	popup_centered()

extends WindowDialog

signal submit(club_name, club_description, club_public)


func _on_Clubs_show_create_club_modal():
	popup_centered()


func _on_Create_pressed():
	var cl_name = $MarginContainer/VBoxContainer/Name/LineEdit.text
	var cl_desc = $MarginContainer/VBoxContainer/Description/LineEdit.text
	var cl_pub = $MarginContainer/VBoxContainer/Public/CheckButton.pressed
	emit_signal("submit", cl_name, cl_desc, cl_pub)
	hide()
	$MarginContainer/VBoxContainer/Name/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Description/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Public/CheckButton.pressed = false

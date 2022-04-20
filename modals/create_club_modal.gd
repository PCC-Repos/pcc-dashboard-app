extends WindowDialog

signal submit(club_name, club_description)

func _on_Clubs_show_create_club_modal():
	popup_centered()

func _on_Create_pressed():
	var cl_name = $MarginContainer/VBoxContainer/Name/LineEdit.text
	var cl_desc = $MarginContainer/VBoxContainer/Description/LineEdit.text
	emit_signal("submit", cl_name, cl_desc)
	hide()
	$MarginContainer/VBoxContainer/Name/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Description/LineEdit.text = ""

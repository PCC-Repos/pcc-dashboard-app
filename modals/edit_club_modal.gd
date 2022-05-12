extends "res://ui_classes/SizedWindowDialog.gd"

signal submit(club_id, club_name, club_description, club_public)

var club_id

func _on_Clubs_show_edit_club_modal(_club_id):
	popup_centered()
	club_id = _club_id


func _on_Save_pressed():
	var cl_name = $MarginContainer/VBoxContainer/Name/LineEdit.text
	var cl_desc = $MarginContainer/VBoxContainer/Description/LineEdit.text
	var cl_pub = $MarginContainer/VBoxContainer/Public/CheckButton.pressed
	emit_signal("submit", club_id, cl_name, cl_desc, cl_pub)
	hide()
	$MarginContainer/VBoxContainer/Name/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Description/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Public/CheckButton.pressed = false


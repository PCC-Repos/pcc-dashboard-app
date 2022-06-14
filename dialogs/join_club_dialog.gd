extends WindowDialog

signal submit(club_id)


func _on_Join_pressed():
	var club_id = $"%ID".text
	emit_signal("submit", club_id)
	$"%ID".text = ""
	hide()


func _on_UserClubs_show_join_club_modal():
	popup_centered()

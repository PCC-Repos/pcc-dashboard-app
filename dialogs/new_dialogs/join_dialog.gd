extends CustomWinDia


signal submit(club_id, desc)


func _on_Join_pressed():
	var club_id = $"%ID".text
	var desc = $"%Reason".text
	
	emit_signal("submit", club_id, desc)
	$"%ID".text = ""
	$"%Reason".text = ""
	popup(false)


func _on_JoinClubButton_pressed():
	popup()

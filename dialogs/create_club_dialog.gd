extends CustomWinDia

signal submit(club_name, club_description, club_public)


func _on_Clubs_show_create_club_modal():
	popup(true)


func _on_Create_pressed():
	var cl_name = $"%Name".text
	var cl_desc = $"%Description".text
	var cl_pub = $"%Public".pressed
	emit_signal("submit", cl_name, cl_desc, cl_pub)
	hide()
	$"%Name".text = ""
	$"%Description".text = ""
	$"%Public".pressed = false

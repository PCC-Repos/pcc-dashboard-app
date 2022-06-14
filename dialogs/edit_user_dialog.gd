extends WindowDialog

signal submit(us_name, us_reason)

var us_id


func _on_Save_pressed():
	var us_name = $"%Name".text
	emit_signal("submit", us_id, us_name, "")
	$"%Name".text = ""
	hide()


func _on_Users_show_edit_user_modal(_us_id):
	us_id = _us_id
	popup_centered()

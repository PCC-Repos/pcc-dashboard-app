extends Control


signal submit(us_name, us_email, us_password)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_BackButton_pressed() -> void:
	get_tree().current_scene.get_node("TabContainer").current_tab = get_tree().current_scene.get_node("TabContainer").find_node("LoginForm").get_index()



func _on_Create_pressed():
	var us_name = $MarginContainer/VBoxContainer/Name/LineEdit.text
	var us_email = $MarginContainer/VBoxContainer/Email/LineEdit.text
	var us_pass = $MarginContainer/VBoxContainer/Password/LineEdit.text
	var us_conf_pass = $MarginContainer/VBoxContainer/ConfirmPassword/LineEdit.text
	if us_pass == us_conf_pass:
		print(us_conf_pass, us_pass)
		print("Not matched!!!")
	emit_signal("submit", us_name, us_email, us_pass)
	$MarginContainer/VBoxContainer/Name/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Email/LineEdit.text = ""
	$MarginContainer/VBoxContainer/Password/LineEdit.text = ""
	$MarginContainer/VBoxContainer/ConfirmPassword/LineEdit.text = ""
	hide()

tool
extends HBoxContainer

export(String, MULTILINE) var text setget set_text, get_text
export(String, MULTILINE) var field_name setget set_field_name, get_field_name
export(bool) var secret setget set_secret, get_secret
export(String, MULTILINE) var placeholder_text setget set_placeholder_text, get_placeholder_text

func _ready():
	set("text", text)
	set("field_name", field_name)
	set("secret", secret)
	set("placeholder_text", placeholder_text)

func set_text(value: String):
	text = value
	if !is_inside_tree():
		return
	$LineEdit.text = value

func get_text():
	if !is_inside_tree():
		return text
	return $LineEdit.text

func set_field_name(value: String):
	field_name = value
	if !is_inside_tree():
		return
	$Label.text = value

func get_field_name():
	if !is_inside_tree():
		return field_name
	return $Label.text

func set_placeholder_text(value: String):
	placeholder_text = value
	if !is_inside_tree():
		return
	$LineEdit.placeholder_text = value

func get_placeholder_text():
	if !is_inside_tree():
		return placeholder_text
	return $LineEdit.placeholder_text

func set_secret(value: bool):
	secret = value
	if !is_inside_tree():
		return
	$LineEdit.secret = value

func get_secret():
	if !is_inside_tree():
		return secret
	return $LineEdit.secret

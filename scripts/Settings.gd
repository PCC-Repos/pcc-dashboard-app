extends Node


var default_path: String = "user://settings.cfg"
var f: ConfigFile = ConfigFile.new()
var err: int

var settings: Array = []

func _ready() -> void:
	err = f.load(default_path)
	if err != OK:
		push_error("Error Loading Setting File! Error: %s" % err)
	else:
		get_settings()

func get_setting(section: String = "Basic", key: String = ""):
	return f.get_value(section, key)

func get_settings() -> Array:
	var array: Array

	var current_section: String
	for section in f.get_sections():
		for key in f.get_section_keys(section):
			if section == current_section:
				array[-1].section[key] = f.get_value(section, key)
			else:
				array.append(
					{
						section : {
							key : f.get_value(section, key)
						}
					}
				)
		current_section = section
	settings = array
	return array

func set_setting(section: String, key: String, value):
	f.set_value(section, key, value)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		err = f.save(default_path)
		if err != OK:
			print("Error Saving Setting File!", " Error: ", err)
			push_error("Error Saving Setting File! Error: %s" % err)

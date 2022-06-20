extends Node


var default_path: String = "user://settings.cfg"
var f: ConfigFile = ConfigFile.new()
var err: int


func _ready() -> void:
	err = f.load(default_path)
	if err != OK:
		print_debug("Error Loading Setting File!", " Error: ", err)
		push_error("Error Loading Setting File! Error: %s" % err)


func get_setting(section: String = "Basic", key: String = ""):
	return f.get_value(section, key)

#func get_settings() -> Array:
#	var array: Array
#	array.append({f.get_sections()})

func set_setting(section: String, key: String, value):
	f.set_value(section, key, value)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		err = f.save(default_path)
		if err != OK:
			print_debug("Error Saving Setting File!", " Error: ", err)
			push_error("Error Saving Setting File! Error: %s" % err)

extends Button
class_name MouseButton

export(int, FLAGS, "Mouse Left", "Mouse Right", "Mouse Middle") var event_button_mask = 1
export(bool) var long_press_enabled = true
export(float) var long_tap_time = 1
export(float) var short_tap_time = 1

signal mouse_button_up(button_index)
signal mouse_button_down(button_index)
signal mouse_pressed(button_index)
signal long_tap(index, long_tap_time)
signal short_tap(index, long_tap_time)

var index_time_dict = {}

func _gui_input(event):
	if event is InputEventMouseButton:
		if (event_button_mask & event.button_mask) == event.button_mask and event.pressed:
			emit_signal("mouse_button_down", event.button_index)
			if action_mode == ACTION_MODE_BUTTON_PRESS:
				emit_signal("mouse_pressed", event.button_index)
		if (event_button_mask & event.button_mask) == event.button_mask and not event.pressed:
			emit_signal("mouse_button_up", event.button_index)
			if action_mode == ACTION_MODE_BUTTON_RELEASE:
				emit_signal("mouse_pressed", event.button_index)
	if event is InputEventScreenTouch:
		if long_press_enabled and event.pressed:
			index_time_dict[event.index] = 0
		elif long_press_enabled and !event.pressed: # Event released.
			if index_time_dict.get(event.index, INF) < short_tap_time:
				emit_signal("short_tap", event.index, index_time_dict[event.index])
			index_time_dict.erase(event.index)

func _process(delta):
	for key in index_time_dict:
		index_time_dict[key] += delta
		print(index_time_dict[key])
		if index_time_dict[key] > long_tap_time:
			print("long press")
			emit_signal("long_tap", key, index_time_dict[key])
			index_time_dict.erase(key)

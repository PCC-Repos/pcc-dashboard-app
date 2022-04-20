extends Button
class_name MouseButton

export(int, FLAGS, "Mouse Left", "Mouse Right", "Mouse Middle") var event_button_mask = 1

signal mouse_button_up(button_index)
signal mouse_button_down(button_index)
signal mouse_pressed(button_index)

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

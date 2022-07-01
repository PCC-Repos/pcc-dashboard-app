extends Node
class_name DevHelper

# A helper script to make API calls
# while the app is in development

var is_active = false

func _ready() -> void:
	if not OS.is_debug_build():
		return

	L.debug("DevHelper", "ready")

func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_QUOTELEFT:
			is_active = not is_active
			if is_active: L.debug("DevHelper", "active")
			else: L.debug("DevHelper", "not active")

		if not is_active:
			return

		if event.scancode == KEY_C:
			var params = CreateClubParams.new()
			params.name = "Test Club " + str(OS.get_unix_time())
			params.description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean quis eros et odio scelerisque lobortis. Mauris commodo blandit nisl, vel tempor erat. Vivamus mollis vestibulum arcu eu pretium. Etiam congue quam odio. Aenean et enim sem. Aenean ultrices convallis nibh vitae suscipit. Duis turpis arcu, vehicula ac urna nec, consequat elementum justo."
			params.public = true
			L.debug("DevHelper", "Creating club", yield(API.rest.create_club(params), "completed"))

		elif event.scancode == KEY_V:
			var params = CreateInviteParams.new()
			params.name = "Test Invite" + str(OS.get_unix_time())
			params.user_id = "44460336795361280"
			params.club_id = "44459814478311424"
			params.description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean quis eros et odio scelerisque lobortis."
			L.debug("DevHelper", "Creating invite", yield(API.rest.create_invite(params), "completed"))

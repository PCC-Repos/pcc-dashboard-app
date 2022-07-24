extends VBoxContainer

var themed_btn = preload("res://ui_classes/ThemedButton.tscn")

onready var applications_vb = $SC/VB
onready var application_popup = $CanvasLayer/ApplicationPopup


func _ready() -> void:
	for child in applications_vb.get_children():
		child.queue_free()

	var partial_applications = yield(API.rest.get_applications("club"), "completed")
	var applications = []
	if partial_applications is HTTPResponse:
		NotificationServer.notify_error("Error in loading applications")
		L.debug("", "get_applications: ", partial_applications)
		return

	for partial_application in partial_applications:
		applications.append(yield(API.rest.get_application(partial_application.id), "completed"))
	for application in applications:
		_create_application(application)


func _create_application(application: Application):
	var btn = themed_btn.instance()
	btn.name = application.id
	btn.text = application.club.name
	btn.connect("pressed", self, "_on_application_pressed", [btn, application])
	applications_vb.add_child(btn)


func _on_application_pressed(which: Button, application: Application):
	var bounds = which.get_global_rect()
	bounds.position += Vector2(which.rect_size.x, 0)
	application_popup.popup()
	application_popup.from_object(application)

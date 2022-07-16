extends CustomWinDia

onready var name_label = $WD/VB/SC/Body/VB/Name
onready var description_label = $WD/VB/SC/Body/VB/Description
onready var created_at_label = $WD/VB/SC/Body/VB/CreatedAt

onready var accept_btn = footer.get_node("OK")
onready var delete_btn = footer.get_node("Cancel")
onready var copyid_btn = $"WD/VB/DebugButton/Panel/CopyIdBtn"

var _application: Application


func _ready() -> void:
	_application = null

	copyid_btn.connect("pressed", self, "_on_copyid_btn_pressed")

	if Store.is_self_admin() or Store.is_self_manager():
		accept_btn.visible = true
	else:
		accept_btn.visible = false


func from_object(application: Application):
	_application = application
	name_label.text = "%s  %s" % [application.applicant.name, application.club.name]
	description_label.text = "[center][u][b]Description:[/b][/u]\n%s" % application.description
	created_at_label.text = "Created At: %s" % application.created_at


func _on_OK_pressed(button: BaseButton):
	button.disabled = true
	NotificationServer.notify_info("Accepting Application...")
#	TODO: implement accept_application()
#	var res = yield(API.rest.accept_application(_application.id), "completed")
#	accept_btn.disabled = false
#
#	if res is HTTPResponse and res.is_error():
#		NotificationServer.notify_error("Error in accepting application.")
#		return
#
#	NotificationServer.notify_info("Application accepted.")
#	_application.accepted = true


func _on_Cancel_pressed(button: BaseButton):
	button.disabled = true

	NotificationServer.notify_info("Deleting application...")
	var res = yield(API.rest.delete_application(_application.id), "completed")
	button.disabled = false

	print(res)
	if res is HTTPResponse and res.is_error():
		NotificationServer.notify_error("Error in deleting application.")
		return

	NotificationServer.notify_info("Application deleted.")
	Store.try_load_user(false, false)


func _on_copyid_btn_pressed():
	OS.clipboard = _application.id


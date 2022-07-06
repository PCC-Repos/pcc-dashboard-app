extends CustomWinDia

onready var applicant_name_label = $WD/VB/SC/Body/VB/ApplicantName
onready var club_name_label = $WD/VB/SC/Body/VB/ClubName
onready var description_label = $WD/VB/SC/Body/VB/Description
onready var created_at_label = $WD/VB/SC/Body/VB/CreatedAt

onready var accept_btn = $WD/VB/HB/AcceptBtn
onready var delete_btn = $WD/VB/HB/DeleteBtn
onready var copyid_btn = $WD/VB/CopyIdBtn

var _application: Application


func _ready() -> void:
	_application = null
	accept_btn.connect("pressed", self, "_on_accept_btn_pressed")
	delete_btn.connect("pressed", self, "_on_delete_btn_pressed")
	copyid_btn.connect("pressed", self, "_on_copyid_btn_pressed")

	if Store.is_self_admin() or Store.is_self_manager():
		accept_btn.visible = true
	else:
		accept_btn.visible = false

	if not OS.is_debug_build():
		copyid_btn.visible = false


func from_object(application: Application):
	_application = application
	applicant_name_label.text = application.applicant.name
	club_name_label.text = application.club.name
	description_label.text = application.description
	created_at_label.text = "Created At: " + application.created_at


func _on_accept_btn_pressed():
	accept_btn.disabled = true
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


func _on_delete_btn_pressed():
	delete_btn.disabled = true

	NotificationServer.notify_info("Deleting application...")
	var res = yield(API.rest.delete_application(_application.id), "completed")
	delete_btn.disabled = false

	print(res)
	if res is HTTPResponse and res.is_error():
		NotificationServer.notify_error("Error in deleting application.")
		return

	NotificationServer.notify_info("Application deleted.")
	Store.try_load_user(false, false)


func _on_copyid_btn_pressed():
	OS.clipboard = _application.id


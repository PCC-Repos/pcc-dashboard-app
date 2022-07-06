extends CustomWinDia

onready var name_label = $WD/VB/SC/Body/VB/Name
onready var inviter_name_label = $WD/VB/SC/Body/VB/InviterName
onready var club_name_label = $WD/VB/SC/Body/VB/ClubName
onready var description_label = $WD/VB/SC/Body/VB/Description
onready var created_at_label = $WD/VB/SC/Body/VB/CreatedAt

onready var accept_btn = $WD/VB/HB/AcceptBtn
onready var reject_btn = $WD/VB/HB/RejectBtn
onready var copyid_btn = $WD/VB/CopyIdBtn

var _invite: PartialInvite

func _ready() -> void:
	_invite = null
	accept_btn.connect("pressed", self, "_on_accept_btn_pressed")
	reject_btn.connect("pressed", self, "_on_reject_btn_pressed")
	copyid_btn.connect("pressed", self, "_on_copyid_btn_pressed")

	if Store.is_self_user():
		reject_btn.text = "Reject"
	elif Store.is_self_admin():
		reject_btn.text = "Revoke"

	if not OS.is_debug_build():
		copyid_btn.visible = false


func from_object(invite: PartialInvite):
	_invite = invite
	name_label.text = invite.name
#	TODO: add this in the API
#	inviter_name_label.text = invite.inviter.name
	club_name_label.text = invite.club.name
	if invite.description:
		description_label.text = invite.description
	created_at_label.text = "Created At: " + invite.created_at

	if invite.accepted:
		accept_btn.visible = false
		reject_btn.visible = false
	else:
		accept_btn.visible = true
		reject_btn.visible = true

func _on_accept_btn_pressed():
	accept_btn.disabled = true
	NotificationServer.notify_info("Accepting Invite...")
	var res = yield(API.rest.accept_invite(_invite.id), "completed")
	accept_btn.disabled = false

	print(res)
	if res is HTTPResponse and res.is_error():
		NotificationServer.notify_error("Error in accepting invite.")
		return

	NotificationServer.notify_info("Invite accepted.")
	_invite.accepted = true


func _on_reject_btn_pressed():
	reject_btn.disabled = true

	var action_string = "Revoking"
	var action_complete_string = "revoked"
	if Store.is_self_user():
		action_string = "Rejecting"
		action_complete_string = "rejected"

	NotificationServer.notify_info("%s Invite..." % action_string)
	var res = yield(API.rest.delete_invite(_invite.id), "completed")
	reject_btn.disabled = false

	print(res)
	if res is HTTPResponse and res.is_error():
		NotificationServer.notify_error("Error in %s invite." % action_string.to_lower())
		return

	NotificationServer.notify_info("Invite %s." % action_complete_string)
	Store.try_load_user(false, false)


func _on_copyid_btn_pressed():
	OS.clipboard = _invite.id


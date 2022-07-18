extends CustomWinDia

onready var name_label = $WD/VB/SC/Body/VB/Name
onready var inviter_name_label = $WD/VB/SC/Body/VB/InviterNameLabel
onready var description_label = $WD/VB/SC/Body/VB/Description
onready var created_at_label = $WD/VB/SC/Body/VB/CreatedAt

onready var accept_btn = footer.get_node("OK")
onready var reject_btn = footer.get_node("Cancel")

onready var copyid_btn = $"WD/VB/DebugButton/Panel/CopyIdBtn"

var _invite: PartialInvite

func _ready() -> void:
	_invite = null

	if Store.is_self_user():
		reject_btn.text = "Reject"
	elif Store.is_self_admin():
		reject_btn.text = "Revoke"

	if not OS.is_debug_build():
		copyid_btn.visible = false


func from_object(invite: PartialInvite):
	_invite = invite
	name_label.text = "%s  %s" % [invite.club.name, invite.name]
#	TODO: add this in the API
#	inviter_name_label.text = invite.inviter.name
	if invite.description:
		description_label.bbcode_text = "[center][u][b]Description:[/b][/u]\n%s" % invite.description
	created_at_label.text = "Created At: " + invite.created_at

	if invite.accepted:
		window_type = Type.Basic
	else:
		window_type = Type.Confirmation

func _on_OK_pressed(button: BaseButton):
	button.disabled = true
	NotificationServer.notify_info("Accepting Invite...")
	var res = yield(API.rest.accept_invite(_invite.id), "completed")
	button.disabled = false

	print(res)
	if res is HTTPResponse and res.is_error():
		NotificationServer.notify_error("Error in accepting invite.")
		return

	NotificationServer.notify_info("Invite accepted.")
	_invite.accepted = true


func _on_Cancel_pressed(button: BaseButton):
	button.disabled = true

	var action_string = "Revoking"
	var action_complete_string = "revoked"
	if Store.is_self_user():
		action_string = "Rejecting"
		action_complete_string = "rejected"

	NotificationServer.notify_info("%s Invite..." % action_string)
	var res = yield(API.rest.delete_invite(_invite.id), "completed")
	button.disabled = false

	print(res)
	if res is HTTPResponse and res.is_error():
		NotificationServer.notify_error("Error in %s invite." % action_string.to_lower())
		return

	NotificationServer.notify_info("Invite %s." % action_complete_string)
	Store.try_load_user(false, false)


func _on_copyid_btn_pressed():
	OS.clipboard = _invite.id


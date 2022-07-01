extends VBoxContainer

var themed_btn = preload("res://ui_classes/ThemedButton.tscn")
var button_group_invite = ButtonGroup.new()

onready var invites_vb = $SC/VB
onready var invite_menu = $CanvasLayer/InviteMenu

enum InviteMenuButtonStates {
	__,
	Accept,
	Reject,
	Revoke,
	CopyID
}

var _clicked_invite: PartialInvite


func _ready() -> void:
	_clicked_invite = null

	# Modify the InviteMenu based on user's permissions
	invite_menu.add_item("Accept", InviteMenuButtonStates.Accept)

	if Store.is_self_user():
		invite_menu.add_item("Reject", InviteMenuButtonStates.Reject)
	elif Store.is_self_admin():
		invite_menu.add_item("Revoke", InviteMenuButtonStates.Revoke)

	if OS.is_debug_build():
		invite_menu.add_separator()
		invite_menu.add_item("Copy ID", InviteMenuButtonStates.CopyID)

	invite_menu.connect("index_pressed", self, "_on_invite_menu_index_pressed")

	for child in invites_vb.get_children():
		child.queue_free()

	for invite in Store.user.invites:
		_create_invite(invite)


func _create_invite(invite: PartialInvite):
	var btn = themed_btn.instance()
	btn.name = invite.id
	btn.text = invite.club.name + ":" + invite.name
	btn.group = button_group_invite
	btn.connect("pressed", self, "_on_invite_pressed", [btn, invite])
	invites_vb.add_child(btn)


func _on_invite_pressed(which: Button, invite: PartialInvite):
	var bounds = which.get_global_rect()
	bounds.position += Vector2(which.rect_size.x, 0)
	invite_menu.popup(bounds)
	invite_menu.set_as_minsize()
	_clicked_invite = invite


func _on_invite_menu_index_pressed(index: int):
	var item_id = invite_menu.get_item_id(index)

	match item_id:
		InviteMenuButtonStates.Accept:
			print("clicked accept")
		InviteMenuButtonStates.Reject:
			print("clicked reject")
		InviteMenuButtonStates.Revoke:
			print("clicked revoke")
		InviteMenuButtonStates.CopyID:
			OS.set_clipboard(_clicked_invite.id)

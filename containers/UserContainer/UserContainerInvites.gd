extends VBoxContainer

var themed_btn = preload("res://ui_classes/ThemedButton.tscn")

onready var invites_vb = $SC/VB
onready var invite_popup = $CanvasLayer/InvitePopup

func _ready() -> void:
	for child in invites_vb.get_children():
		child.queue_free()

	for invite in Store.user.invites:
		if invite.accepted: continue
		_create_invite(invite)


func _create_invite(invite: PartialInvite):
	var btn = themed_btn.instance()
	btn.name = invite.id
	btn.text = invite.club.name + ":" + invite.name
	btn.connect("pressed", self, "_on_invite_pressed", [btn, invite])
	invites_vb.add_child(btn)


func _on_invite_pressed(which: Button, invite: PartialInvite):
	var bounds = which.get_global_rect()
	bounds.position += Vector2(which.rect_size.x, 0)
	invite_popup.popup()
	invite_popup.from_object(invite)

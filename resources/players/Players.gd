extends VBoxContainer


export var tween_duration: float = 0.3

var themed_btn = preload("res://ui_classes/ThemedButton.tscn")
var button_group_invite = ButtonGroup.new()
var button_group_award = ButtonGroup.new()

onready var player_name_label = $PlayerName

onready var invites_vb = $HB/Invites/SC/VB
onready var awards_vb = $HB/Awards/SC/VB


func _ready():
	player_name_label.text = Store.user.name

	connect("visibility_changed", self, "_on_visibility_changed")

	for child in invites_vb.get_children():
		child.queue_free()
	for child in awards_vb.get_children():
		child.queue_free()

	for invite in Store.user.invites:
		_create_invite(invite)
	for award in Store.user.awards:
		_create_award(award)


func _create_invite(invite: PartialInvite):
	var btn = themed_btn.instance()
	btn.name = invite.id
	btn.text = invite.club.name
	btn.group = button_group_invite
	invites_vb.add_child(btn)


func _create_award(award: PartialUserAward):
	var btn = themed_btn.instance()
	btn.name = award.id
	btn.text = award.name
	btn.group = button_group_award
	awards_vb.add_child(btn)


func _on_visibility_changed() -> void:
	if visible: owner.get_recursive_children(self)

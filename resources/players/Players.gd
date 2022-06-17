extends VBoxContainer


var themed_btn = preload("res://ui_classes/ThemedButton.tscn")
var button_group_invite = ButtonGroup.new()
var button_group_award = ButtonGroup.new()


func _ready():
	$"%PlayerName".text = GlobalUserState.user.name

	var invites = GlobalUserState.user.invites
	for invite in invites:
		_create_invite(invite)
	var awards = GlobalUserState.user.awards
	for award in awards:
		_create_invite(award)


func _create_invite(invite: PartialInvite):
	var btn = themed_btn.instance()
	btn.name = invite.id
	btn.text = invite.club.name
	btn.group = button_group_invite
	$"%Invites/VBoxContainer".add_child(btn)


func _create_award(award: PartialUserAward):
	var btn = themed_btn.instance()
	btn.name = award.id
	btn.text = award.name
	btn.group = button_group_award
	$"%Awards/VBoxContainer".add_child(btn)


extends VBoxContainer


var themed_btn = preload("res://ui_classes/ThemedButton.tscn")
var button_group_invite = ButtonGroup.new()
var button_group_award = ButtonGroup.new()
var button_group_agent = ButtonGroup.new()


func _ready():
	if not OS.is_debug_build():
		var partial_club: PartialClub = GlobalUserState.user.clubs[0]
		$"%Name".text = partial_club.name
		$"%Description".text = partial_club.description
		var club = yield(GlobalUserState.client.get_rest_client().get_club(partial_club.id), "completed") as Club
		if club is HTTPResponse and club.is_error():
			NotificationServer.notify_error("Something went wrong while trying to fetch the club.")
			return
		var invites = club.invites
		for invite in invites:
			_create_invite(invite)
		var members = club.members
		for member in members:
			_create_member(member)

		var agents = yield(GlobalUserState.client.get_rest_client().get_users(true), "completed")
		if agents is HTTPResponse and agents.is_error():
			NotificationServer.notify_error("Something went wrong while trying to fetch the agents.")
			return
		for agent in agents:
			_create_agent(agent)


func _create_invite(invite: PartialInvite):
	var btn = themed_btn.instance()
	btn.name = invite.id
	btn.text = invite.club.name
	btn.group = button_group_invite
	$"%ClubApplication/VBoxContainer".add_child(btn)


func _create_member(club_member: PartialClubMember):
	var btn = themed_btn.instance()
	btn.name = club_member.user.id
	btn.text = club_member.user.name
	btn.group = button_group_award
	$"%Members/VBoxContainer".add_child(btn)


func _create_agent(agent: PartialUser):
	var btn = themed_btn.instance()
	btn.name = agent.id
	btn.text = agent.name
	btn.group = button_group_agent
	$"%Agents/VBoxContainer".add_child(btn)

# Copyright 2022 Delano Lourenco
# MIT LICENSE
# https://github.com/3ddelano/proclubsfederation-api-godot

class_name Invite
extends Reference
var description: String
var id: String
var created_at: String
var club: PartialClub
var user: PartialUser
var inviter: PartialUser

func from_json(json: Dictionary) -> Invite:
	description = json["description"]
	id = json["id"]
	created_at = json["created_at"]
	club = PartialClub.new().from_json(json["club"])
	user = PartialUser.new().from_json(json["user"])
	inviter = PartialUser.new().from_json(json["inviter"])
	return self

func get_class() -> String:
	return "Invite"

func _to_string() -> String:
	return "Invite(description=%s, id=%s, created_at=%s, club=%s, user=%s, inviter=%s)" % [description, id, created_at, club, user, inviter]

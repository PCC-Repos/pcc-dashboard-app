extends VBoxContainer


var themed_btn = preload("res://ui_classes/ThemedButton.tscn")

onready var clubs_vb = $SC/VB
#onready var club_popup = $CanvasLayer/clubPopup


func _ready() -> void:
	for child in clubs_vb.get_children():
		child.queue_free()
	var clubs = yield(API.rest.get_clubs(), "completed")
	for club in clubs:
		_create_club(club)
	
	API.ws.connect("club_create", self, "_club_created")
	API.ws.connect("club_delete", self, "_club_deleted")


func _create_club(club: PartialClub):
	var node = find_node("*%s*" % club.id, true, false)
	if node:
		# Todo: Figure out a way to differentiate club creation for user and admin!
		return
	var btn = themed_btn.instance()
	btn.name = club.id
	btn.text = club.name
	btn.connect("pressed", self, "_on_club_pressed", [btn, club])
	clubs_vb.add_child(btn)


func _delete_club(club: PartialClub):
	var node = find_node("*%s*" % club.id, true, false)
	if node:
		node.queue_free()
	

func _club_created(club: PartialClub):
	print("club created")
	_create_club(club)

func _club_deleted(club: PartialClub):
	print("club deleted")
	_delete_club(club)

func _on_club_pressed(which: Button, club: PartialClub):
	if club.name == "Dev Club 001":
		return
	var res = yield(API.rest.delete_club(club.id), "completed")
	if res is HTTPResponse and res.is_error():
		NotificationServer.notify_error(str(res))
		return
	NotificationServer.notify_info("Club deleted successfully!")
#	var bounds = which.get_global_rect()
#	bounds.position += Vector2(which.rect_size.x, 0)
#	club_popup.popup()
#	club_popup.from_object(club.club)

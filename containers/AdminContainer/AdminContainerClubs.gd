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


func _create_club(club: PartialClub):
	var btn = themed_btn.instance()
	btn.name = club.id
	btn.text = club.name
#	btn.connect("pressed", self, "_on_club_pressed", [btn, club])
	clubs_vb.add_child(btn)


func _on_club_pressed(which: Button, club: PartialClub):
	pass
#	var bounds = which.get_global_rect()
#	bounds.position += Vector2(which.rect_size.x, 0)
#	club_popup.popup()
#	club_popup.from_object(club.club)

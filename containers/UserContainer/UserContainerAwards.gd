extends VBoxContainer

var themed_btn = preload("res://ui_classes/ThemedButton.tscn")

onready var awards_vb = $SC/VB
onready var award_popup = $CanvasLayer/AwardPopup


func _ready() -> void:
	for child in awards_vb.get_children():
		child.queue_free()

	for award in Store.user.awards:
		_create_award(award)


func _create_award(award: PartialAward):
	var btn = themed_btn.instance()
	btn.name = award.id
	btn.text = award.name
	btn.connect("pressed", self, "_on_award_pressed", [btn, award])
	awards_vb.add_child(btn)


func _on_award_pressed(which: Button, award: PartialAward):
	var bounds = which.get_global_rect()
	bounds.position += Vector2(which.rect_size.x, 0)
	award_popup.popup()
	award_popup.from_object(award)

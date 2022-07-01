extends VBoxContainer


var themed_btn = preload("res://ui_classes/ThemedButton.tscn")
var button_group_award = ButtonGroup.new()

onready var player_name_label = $PlayerName
onready var applications_vb = $HB/Applications/SC/VB
onready var awards_vb = $HB/Awards/SC/VB


func _ready():
	player_name_label.text = Store.user.name

	connect("visibility_changed", self, "_on_visibility_changed")

	# Remove temporary items
	for container in [applications_vb, awards_vb]:
		for child in container.get_children():
			child.queue_free()

	for award in Store.user.awards:
		_create_award(award)


func _create_award(award: PartialUserAward):
	var btn = themed_btn.instance()
	btn.name = award.id
	btn.text = award.name
	btn.group = button_group_award
	awards_vb.add_child(btn)


func _on_visibility_changed() -> void:
	if visible: owner.get_recursive_children(self)

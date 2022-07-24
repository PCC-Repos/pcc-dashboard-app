extends VBoxContainer


var themed_btn = preload("res://ui_classes/ThemedButton.tscn")
var button_group_award = ButtonGroup.new()

onready var player_name_label = $PlayerName
onready var applications_vb = $HB/Applications/SC/VB
onready var awards_vb = $HB/Awards/SC/VB


func _ready():
	player_name_label.text = Store.user.name
	connect("visibility_changed", self, "_on_visibility_changed")


func _on_visibility_changed() -> void:
	if visible: owner.get_recursive_children(self)

extends CustomWinDia


onready var tab_buttons: = $"%SideButtonContainer"
onready var tab_container: = $"%TabContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(tab_buttons.get_child(0) as Button).group.connect("pressed", self, "tab_changed")

	if get_parent() == get_tree().root:
		popup()

func tab_changed(button: Button):
	tab_container.current_tab = button.get_index()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

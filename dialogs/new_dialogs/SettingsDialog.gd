extends CustomWinDia


onready var basic_btn: = $WD/VB/SC/Body/HSC/PC/SideButtonContainer/BasicBtn
onready var advanced_btn: = $WD/VB/SC/Body/HSC/PC/SideButtonContainer/AdvancedBtn
onready var tab_container: = $WD/VB/SC/Body/HSC/SC/SettingsTabContainer

func _ready() -> void:

	basic_btn.connect("pressed", self, "_on_basic_btn_pressed") # warning-ignore:return_value_discarded
	advanced_btn.connect("pressed", self, "_on_advanced_btn_pressed") # warning-ignore:return_value_discarded

	if get_parent() == get_tree().root:
		popup()


func _on_basic_btn_pressed():
	tab_container.current_tab = 0


func _on_advanced_btn_pressed():
	tab_container.current_tab = 1


extends CustomWinDia


func _ready():
	if not OS.is_debug_build():
		popup()


func _on_ok_btn_pressed(_button: BaseButton) -> void:
	close()

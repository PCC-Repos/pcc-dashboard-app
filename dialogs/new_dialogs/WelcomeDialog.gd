extends CustomWinDia


func _ready():
	if not OS.is_debug_build():
		popup()


func _on_OK_pressed(button: BaseButton) -> void:
	close()

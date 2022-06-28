extends CustomWinDia

onready var ok_btn = $WD/VB/OkBtn


func _ready():
	close_btn.hide()
	popup()

	ok_btn.connect("pressed", self, "_on_ok_btn_pressed")


func _on_ok_btn_pressed():
	close()

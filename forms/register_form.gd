extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://forms/login_form.tscn")

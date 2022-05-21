extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_BackButton_pressed() -> void:
	get_tree().current_scene.get_node("TabContainer").current_tab = 0

tool
extends TextEdit

export var placeholder_text: String setget set_placeholder_text, get_placeholder_text

func _ready() -> void:
	$Label.text = placeholder_text

func _on_LineEdit_text_changed() -> void:
	$Label.visible = text.empty()


func set_placeholder_text(new: String):
	$Label.text = new
	placeholder_text = new

func get_placeholder_text():
	return placeholder_text

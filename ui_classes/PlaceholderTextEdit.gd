tool
extends TextEdit

export var placeholder_text: String setget set_placeholder_text, get_placeholder_text
export(float, 0, 1) var placeholder_alpha: float = 1 setget set_placeholder_alpha, get_placeholder_alpha

func _ready() -> void:
	$Label.text = placeholder_text
	$Label.add_color_override("font_color", get_color("placeholder_text_color"))

func _on_LineEdit_text_changed() -> void:
	$Label.visible = text.empty()


func set_placeholder_text(new: String):
	placeholder_text = new
	if is_inside_tree(): $Label.text = placeholder_text

func get_placeholder_text():
	return placeholder_text

func set_placeholder_alpha(new: float):
	placeholder_alpha = new
	if is_inside_tree():
		var color: Color = $Label.get_color("font_color")
		color.a = placeholder_alpha
		$Label.add_color_override("font_color", color)

func get_placeholder_alpha():
	return placeholder_alpha

tool
extends Panel
class_name CustomWinDia

export var title: String = "INdIE's Chosen Title" setget set_title
#export var exclusive: bool = true
export var resizable: bool = true setget set_resizable
export var tween_speed: float = 3 # The greater, the faster! (pixels/second)


func _ready() -> void:
	set("title", title)
	set("resizable", resizable)
	set("tween_speed", tween_speed)
	$"%WindowDialog".get_close_button().hide()
	$"%WindowDialog".resizable = resizable
	$"%WindowDialog".rect_min_size.x = $"%TitleBar".rect_size.x + 20 + $"%CloseButton".rect_size.x
	$"%TitleBar".rect_position.y = 10
	$"%CloseButton".rect_position = Vector2($"%WindowDialog".rect_size.x - $"%CloseButton".rect_size.x, $"%CloseButton".rect_size.y)
	if not Engine.editor_hint:
		for idx in range(1, get_child_count()):
			change_parent_to_body(get_child(idx))
		popup(true)

func popup(show: bool = true):
#	$"%"
	$"%WindowDialog".rect_pivot_offset = $"%WindowDialog".rect_size/2
	if show:
		show()
		$"%WindowDialog".popup()
		var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
		tween.tween_property($"%WindowDialog", "rect_scale:x", 1.0, 1/tween_speed).from(0.0)
		tween.tween_property($"%WindowDialog", "modulate", Color.white, 1/tween_speed).from(Color(10, 10, 10))
		tween.chain().tween_property($"%TitleBar", "rect_position:y", -$"%TitleBar".rect_size.y/2, 1/tween_speed)
		tween.tween_property($"%CloseButton", "rect_position", Vector2($"%WindowDialog".rect_size.x - $"%CloseButton".rect_size.x, -$"%CloseButton".rect_size.y), 1/tween_speed)
	else:
		var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
		tween.tween_property($"%TitleBar", "rect_position:y", 10.0, 1/tween_speed)
		tween.tween_property($"%CloseButton", "rect_position", Vector2($"%WindowDialog".rect_size.x - $"%CloseButton".rect_size.x, $"%CloseButton".rect_size.y), 1/tween_speed)
		tween.tween_property($"%WindowDialog", "rect_scale:x", 0.0, 1/tween_speed)
		tween.tween_property($"%WindowDialog", "modulate", Color(10, 10, 10), 1/tween_speed)
		yield(tween, "finished")
		$"%WindowDialog".hide()
		hide()


func _on_CloseButton_pressed() -> void:
	popup(false)


#func _on_Panel_gui_input(event: InputEvent) -> void:
#	print_debug(event.to_string())
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and not exclusive:
#			popup(false)

func _on_ScrollContainer_resized() -> void:
	if is_zero_approx($"%Body".get_parent().rect_size.y):
		$"%WindowDialog".rect_min_size.y = $"%WindowDialog".rect_size.y


func set_title(new: String):
	title = new
	if !is_inside_tree():
		return
	$"%TitleBar".text = title

func set_resizable(new: bool):
	resizable = new
	if !is_inside_tree():
		return
	$"%WindowDialog".resizable = resizable

func change_parent_to_body(node):
	node.get_parent().remove_child(node)
	$"%Body".add_child(node)

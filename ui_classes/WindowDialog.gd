tool
extends Panel
class_name CustomWinDia

export var title: String = "INdIE's Chosen Title" setget set_title
export var exclusive: bool setget set_exclusive
export var resizable: bool = true setget set_resizable
export var tween_speed: float = 3 # The greater, the faster! (pixels/second)

var pre_rect_size: Vector2

func _ready() -> void:
	set("title", title)
	set("resizable", resizable)
	set("tween_speed", tween_speed)
	$"%WindowDialog".get_close_button().hide()
	$"%WindowDialog".resizable = resizable
	$"%WindowDialog".rect_min_size.x = $"%TitleBar".rect_size.x + 20 + $"%CloseButton".rect_size.x
	if not Engine.editor_hint:
		$"%TitleBar".rect_position.y = 10
		$"%CloseButton".rect_position = Vector2($"%WindowDialog".rect_size.x - $"%CloseButton".rect_size.x, $"%CloseButton".rect_size.y)
#	$"%WindowDialog".rect_pivot_offset = $"%WindowDialog".rect_size/2
	if not Engine.editor_hint:
		for idx in range(1, get_child_count()):
			print_debug(idx)
			change_parent_to_body(get_child(idx))
	pre_rect_size = $"%WindowDialog".rect_position

	get_recursive_children()


func popup(show: bool = true):
	if show:
		$"%WindowDialog".rect_pivot_offset = $"%WindowDialog".rect_size/2
		show()
		$"%WindowDialog".show()
		$"%WindowDialog".rect_position = pre_rect_size
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
		pre_rect_size = $"%WindowDialog".rect_position
		$"%WindowDialog".hide()
		hide()


func _on_CloseButton_pressed() -> void:
	popup(false)

func get_body_node():
	return $"%Body"

func _on_Panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not exclusive:
			popup(false)

func _on_ScrollContainer_resized() -> void:
	if is_zero_approx($"%Body".get_parent().rect_size.y):
		$"%WindowDialog".rect_min_size.y = $"%WindowDialog".rect_size.y


func set_title(new: String):
	title = new
	if is_inside_tree():
		$"%TitleBar".text = title

func set_resizable(new: bool):
	resizable = new
	if is_inside_tree():
		$"%WindowDialog".resizable = resizable

func set_exclusive(new: bool):
	exclusive = new
	if is_inside_tree():
		$"%WindowDialog".popup_exclusive = exclusive

func change_parent_to_body(node: Node):
	var unique_node: = node.unique_name_in_owner
	node.get_parent().remove_child(node)
	$"%Body".add_child(node)
	node.unique_name_in_owner = unique_node

func get_close_button():
	return $"%CloseButton"

func close():
	popup(false)

func get_recursive_children(root: Node = self):
	for node in root.get_children():
		if node.get_child_count() == 0:
			if node is Button:
				node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			get_recursive_children(node)

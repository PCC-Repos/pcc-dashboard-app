tool
extends Panel
class_name CustomWinDia

export var title: String = "INdIE's Chosen Title" setget set_title
export var exclusive: bool setget set_exclusive
export var resizable: bool = true setget set_resizable
export var tween_speed: float = 3 # The greater, the faster! (pixels/second)

var pre_rect_size: Vector2

onready var window_dialog = $WD
onready var close_btn = $WD/CloseBtn
onready var body = $WD/VB/SC/Body
onready var title_bar = $WD/TitleBar


func _ready() -> void:
	set("title", title)
	set("resizable", resizable)
	set("tween_speed", tween_speed)

	window_dialog.get_close_button().hide()
	window_dialog.resizable = resizable
	window_dialog.rect_min_size.x = title_bar.rect_size.x + 20 + close_btn.rect_size.x

	if not Engine.editor_hint:
		hide()
		title_bar.rect_position.y = 10
		close_btn.rect_position = Vector2(window_dialog.rect_size.x - close_btn.rect_size.x, close_btn.rect_size.y)

#		for idx in range(1, get_child_count()):
#			print(idx)
#			change_parent_to_body(get_child(idx))

	pre_rect_size = window_dialog.rect_position

	get_recursive_children()

	# warning-ignore:return_value_discarded
	close_btn.connect("pressed", self, "_on_close_btn_pressed")
	# warning-ignore:return_value_discarded
	connect("gui_input", self, "_on_gui_input")
	# warning-ignore:return_value_discarded
	body.get_parent().connect("resized", self, "_on_sc_resized")


func popup(show: bool = true):
	if show:
		window_dialog.rect_pivot_offset = window_dialog.rect_size/2
		show()
		window_dialog.show()
		window_dialog.rect_position = pre_rect_size
		var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
		tween.tween_property(window_dialog, "rect_scale:x", 1.0, 1/tween_speed).from(0.0)
		tween.tween_property(window_dialog, "modulate", Color.white, 1/tween_speed).from(Color(10, 10, 10))
		tween.chain().tween_property(title_bar, "rect_position:y", -title_bar.rect_size.y/2, 1/tween_speed)
		tween.tween_property(close_btn, "rect_position", Vector2(window_dialog.rect_size.x - close_btn.rect_size.x, -close_btn.rect_size.y), 1/tween_speed)
	else:
		var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
		tween.tween_property(title_bar, "rect_position:y", 10.0, 1/tween_speed)
		tween.tween_property(close_btn, "rect_position", Vector2(window_dialog.rect_size.x - close_btn.rect_size.x, close_btn.rect_size.y), 1/tween_speed)
		tween.tween_property(window_dialog, "rect_scale:x", 0.0, 1/tween_speed)
		tween.tween_property(window_dialog, "modulate", Color(10, 10, 10), 1/tween_speed)
		yield(tween, "finished")
		pre_rect_size = window_dialog.rect_position
		window_dialog.hide()
		hide()


func _on_close_btn_pressed() -> void:
	popup(false)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not exclusive:
			popup(false)


func _on_sc_resized() -> void:
	if is_zero_approx($"%Body".get_parent().rect_size.y):
		window_dialog.rect_min_size.y = window_dialog.rect_size.y


func set_title(new: String):
	title = new
	if is_inside_tree():
		title_bar.text = title

func set_resizable(new: bool):
	resizable = new
	if is_inside_tree():
		window_dialog.resizable = resizable

func set_exclusive(new: bool):
	exclusive = new
	if is_inside_tree():
		window_dialog.popup_exclusive = exclusive

func change_parent_to_body(node: Node):
	var unique_node: = node.unique_name_in_owner
	node.get_parent().remove_child(node)
	body.add_child(node)
	node.unique_name_in_owner = unique_node

func close():
	popup(false)

func get_recursive_children(root: Node = self):
	for node in root.get_children():
		if node.get_child_count() == 0:
			if node is Button:
				node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			get_recursive_children(node)

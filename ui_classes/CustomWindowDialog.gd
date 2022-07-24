tool
extends Panel
class_name CustomWinDia


enum Type {
	Basic,
	Accept,
	Confirmation
}

export var title: String = "INdIE's Chosen Title" setget set_title
export var exclusive: bool setget set_exclusive
export var resizable: bool = true setget set_resizable
export(Type) var window_type: int = 0 setget set_type
export var tween_speed: float = 3 # The greater, the faster! (pixels/second)

var pre_rect_size: Vector2

onready var window_dialog: = $WD
onready var title_bar: = window_dialog.get_node("TitleBar")
onready var close_button: = window_dialog.get_node("CloseButton")
onready var body: = $"%Body"
onready var footer: = $"%FooterContainer"
onready var ok_button: = footer.get_node("OK")
onready var cancel_button: = footer.get_node("Cancel")
onready var debug_button: = $"%DebugButton"

# Needed because script is tool, so onready vars load only when running the scene
# not in editor
func _init_vars():
	window_dialog = $WD
	title_bar = window_dialog.get_node("TitleBar")
	close_button = window_dialog.get_node("CloseButton")
	body = $"%Body"
	footer = $"%FooterContainer"
	ok_button = footer.get_node("OK")
	cancel_button = footer.get_node("Cancel")
	debug_console = $"%DebugConsole/Panel"
	copy_id_btn = debug_console.get_node("CopyId")

func _ready() -> void:
	_init_vars()
	ok_button.connect("pressed", self, "_on_ok_btn_pressed", [ok_button]) # warning-ignore:return_value_discarded
	close_button.connect("pressed", self, "_on_close_btn_pressed", [close_button]) # warning-ignore:return_value_discarded
	cancel_button.connect("pressed", self, "_on_cancel_btn_pressed", [cancel_button]) # warning-ignore:return_value_discarded
	debug_console.get_parent().connect("toggled", self, "_on_debug_console_toggled") # warning-ignore:return_value_discarded
	body.get_parent().connect("resized", self, "_on_scroll_container_resized") # warning-ignore:return_value_discarded
	copy_id_btn.connect("pressed", self, "_on_copyid_btn_pressed", [copy_id_btn]) # warning-ignore:return_value_discarded

	set("title", title)
	set("resizable", resizable)
	set("tween_speed", tween_speed)
	set("window_type", window_type)

	# Hide original WindowDialog's close btn
	window_dialog.get_close_button().hide()
	window_dialog.resizable = resizable
	window_dialog.rect_min_size.x = title_bar.rect_size.x + 20 + close_button.rect_size.x

	# If we are not running in tool mode
	if not Engine.editor_hint:
		title_bar.rect_position.y = 10
		close_button.rect_position = Vector2(window_dialog.rect_size.x - close_button.rect_size.x, close_button.rect_size.y)
	pre_rect_size = window_dialog.rect_position

	get_recursive_children()

	debug_console.visible = OS.is_debug_build()

	# For Standalone Debugging purpose only
	if get_parent() == get_tree().root:
		popup()
		self.window_type = window_type

	hide()

func _init():
	if is_inside_tree():
		_init_vars()

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
		tween.tween_property(close_button, "rect_position", Vector2(window_dialog.rect_size.x - close_button.rect_size.x, -close_button.rect_size.y), 1/tween_speed)
	else:
		var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
		tween.tween_property(title_bar, "rect_position:y", 10.0, 1/tween_speed)
		tween.tween_property(close_button, "rect_position", Vector2(window_dialog.rect_size.x - close_button.rect_size.x, close_button.rect_size.y), 1/tween_speed)
		tween.tween_property(window_dialog, "rect_scale:x", 0.0, 1/tween_speed)
		tween.tween_property(window_dialog, "modulate", Color(10, 10, 10), 1/tween_speed)
		yield(tween, "finished")
		pre_rect_size = window_dialog.rect_position
		window_dialog.hide()
		hide()
	_reset_debug_console()

func _on_close_btn_pressed(_button: BaseButton) -> void:
	popup(false)

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not exclusive:
			popup(false)

func _on_scroll_container_resized() -> void:
	if is_zero_approx(body.get_parent().rect_size.y):
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

func set_type(new: int):
	window_type = new
	if is_inside_tree():
		ok_button.visible = not (window_type == Type.Basic or window_type == Type.Accept)
		cancel_button.visible = not (window_type == Type.Basic)

func close():
	popup(false)

func get_recursive_children(root: Node = self):
	for node in root.get_children():
		if node.get_child_count() == 0:
			if node is Button:
				node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			get_recursive_children(node)

func _on_ok_btn_pressed(_button: BaseButton) -> void:
	pass # Replace with function body.

func _on_cancel_btn_pressed(_button: BaseButton) -> void:
	pass # Replace with function body.

func _on_copyid_btn_pressed(_button: BaseButton) -> void:
	pass

func _reset_debug_console():
	debug_console.get_parent().pressed = false
	debug_console.visible = false

func _on_debug_console_toggled(button_pressed: bool) -> void:
	if button_pressed:
		debug_console.get_parent().icon = preload("res://assets/images/UI/Eye Open.svg")
	else:
		debug_console.get_parent().icon = preload("res://assets/images/UI/Eye Close.svg")

	debug_console.visible = not debug_console.visibles

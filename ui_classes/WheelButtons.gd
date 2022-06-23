extends Control


export var speed: float = 10
export var radius: float = 100
export var buttons: Dictionary = {}
export var button_container: NodePath

var button_scene: PackedScene = PackedScene.new()
var is_mouse_in: bool = true
var pointing_angle: = 0

onready var center_wheel: = $"%MainButton"
onready var angular_seperation: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# warning-ignore:return_value_discarded
	button_scene.pack(center_wheel.get_node("Buttons").get_child(0))

	center_wheel.hide()
	$"%BackLight".hide()
	center_wheel.rect_pivot_offset = center_wheel.rect_size/2
	center_wheel.get_node("Buttons").get_child(0).queue_free()

	for button in center_wheel.get_node("Buttons").get_children():
		button.queue_free()

	if buttons:
		for button in buttons:
			if buttons.has(button):
				var new: Button = button_scene.instance()
				new.text = button
				new.icon = buttons[button]
				center_wheel.get_node("Buttons").add_child(new)
# warning-ignore:return_value_discarded
				new.connect("pressed", self, "button_pressed", [new.get_index()])
			yield(get_tree(), "idle_frame")
		for button in center_wheel.get_node("Buttons").get_children():
			button.set_meta("angle", angular_seperation * button.get_index())
#			button.text = str(button.get_meta("angle"))
	pass

func _process(_delta: float) -> void:
	$"%BackLight".rect_global_position = center_wheel.rect_global_position - $"%BackLight".rect_size/2 + center_wheel.rect_size/2

	pointing_angle = rad2deg((center_wheel.get_local_mouse_position() - center_wheel.rect_size/2).angle()) + (90 - center_wheel.radial_fill_degrees/2)
	if sign(pointing_angle) == -1: pointing_angle = 360 + pointing_angle

	center_wheel.get_node("Buttons").get_child(0).text = str(pointing_angle)
	center_wheel.radial_initial_angle = pointing_angle - (center_wheel.radial_fill_degrees/2)
# warning-ignore:integer_division
	angular_seperation = 360 / center_wheel.get_child_count()

# warning-ignore:narrowing_conversion
	var selected_child: int = int(round(pointing_angle / angular_seperation/2)) * sign(int(round(pointing_angle / angular_seperation/2)))
	center_wheel.get_node("Buttons").get_child(int(clamp(selected_child, 0, center_wheel.get_node("Buttons").get_child_count() - 1))).grab_focus()

	if is_mouse_in:
		if Input.is_action_just_pressed("wheel_button"):
				wheel_buttons_visible()
		elif Input.is_action_just_released("wheel_button"):
				wheel_buttons_visible(false)
#				center_wheel.get_child(selected_child).pressed = false
#				yield(get_tree(), "idle_frame")
#				center_wheel.get_child(selected_child).pressed = true

	center_wheel.get_node("Buttons").get_child(1).text = str(round(pointing_angle / (angular_seperation/2)))


func wheel_buttons_visible(value: bool = true):
	if value:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		center_wheel.show()
		$"%BackLight".show()
		center_wheel.rect_global_position = get_global_mouse_position() - center_wheel.rect_size/2
		center_wheel.rect_scale = Vector2.ONE
		center_wheel.modulate.a = 1
		var tween: SceneTreeTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
# warning-ignore:return_value_discarded
		tween.tween_property($"%BackLight", "self_modulate:a", 1.0, 2/speed)
		for button in center_wheel.get_node("Buttons").get_children():
			if button is Button:
# warning-ignore:return_value_discarded
				tween.tween_property(button, "modulate:a", 1.0, 1/speed).from(0.0)
# warning-ignore:return_value_discarded
				tween.tween_property(button, "rect_position", (Vector2.UP * (radius + button.rect_size.length())).rotated(deg2rad(angular_seperation * button.get_index() + 1)), 1/speed)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		Input.warp_mouse_position(center_wheel.rect_global_position + center_wheel.rect_size/2)
		var tween: SceneTreeTween
		for button in center_wheel.get_node("Buttons").get_children():
			if button is Button:
				tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
# warning-ignore:return_value_discarded
				tween.tween_property(button, "modulate:a", 0.0, 1/speed)
# warning-ignore:return_value_discarded
				tween.tween_property(button, "rect_position", Vector2.ZERO, 1/speed)

# warning-ignore:return_value_discarded
		tween.chain().set_trans(Tween.TRANS_BACK)

# warning-ignore:return_value_discarded
		tween.tween_property(center_wheel, "rect_scale", Vector2.ZERO, 2/speed)
# warning-ignore:return_value_discarded
		tween.tween_property(center_wheel, "modulate:a", 0.0, 2/speed)
# warning-ignore:return_value_discarded
		tween.tween_property($"%BackLight", "self_modulate:a", 0.0, 2/speed).set_trans(Tween.TRANS_QUART)
		yield(tween, "finished")
		center_wheel.hide()
		$"%BackLight".hide()

func button_pressed(index: int):
	get_node(button_container).get_child(index).pressed = false
	yield(get_tree(), "idle_frame")
	get_node(button_container).get_child(index).pressed = true
	print("Switched Tab")

#func is_mouse_in(value: bool) -> void:
#	is_mouse_in = value
#	set_process(value)


func _on_WheelButtons_visibility_changed() -> void:
	for child in get_children():
		child.visible = visible

extends Control


export var speed: float = 10
export var radius: float = 100
export var buttons: Dictionary = {}
export var button_container: NodePath

var button_scene: PackedScene = PackedScene.new()
var is_mouse_in: bool = true
var pointing_angle: = 0

onready var main_button = $"%MainButton"
onready var angular_seperation: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_scene.pack(main_button.get_child(0))

	main_button.hide()
	$"%BackLight".hide()
	main_button.rect_pivot_offset = main_button.rect_size/2
	main_button.get_child(0).queue_free()

	for button in main_button.get_children():
		button.queue_free()

	if buttons:
		for button in buttons:
			if buttons.has(button):
				var new: Button = button_scene.instance()
				new.text = button
				new.icon = buttons[button]
				main_button.add_child(new)
				new.connect("pressed", self, "button_pressed", [new.get_index()])
			yield(get_tree(), "idle_frame")
		for button in main_button.get_children():
			button.set_meta("angle", angular_seperation * button.get_index())
#			button.text = str(button.get_meta("angle"))
	pass

func _process(_delta: float) -> void:
	$"%BackLight".global_position = main_button.rect_global_position + main_button.rect_size/2
	pointing_angle = rad2deg((main_button.get_local_mouse_position() - main_button.rect_size/2).angle()) + (90 - main_button.radial_fill_degrees/2)
	main_button.get_child(0).text = str(pointing_angle)
	main_button.radial_initial_angle = pointing_angle
	angular_seperation = 360 / main_button.get_child_count()

	var selected_child: int = int(round(pointing_angle / angular_seperation/2)) * sign(int(round(pointing_angle / angular_seperation/2)))
	main_button.get_child(selected_child).grab_focus()

	if is_mouse_in:
		if Input.is_action_just_pressed("wheel_button"):
				wheel_buttons_visible()
		elif Input.is_action_just_released("wheel_button"):
				wheel_buttons_visible(false)
				main_button.get_child(selected_child).pressed = false
				yield(get_tree(), "idle_frame")
				main_button.get_child(selected_child).pressed = true

	main_button.get_child(1).text = str(round(pointing_angle / angular_seperation/2))


func wheel_buttons_visible(value: bool = true):
	if value:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		main_button.show()
		$"%BackLight".show()
		main_button.rect_global_position = get_global_mouse_position() - main_button.rect_size/2
		main_button.rect_scale = Vector2.ONE
		main_button.modulate.a = 1
		var tween: SceneTreeTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
		tween.tween_property($"%BackLight", "energy", 2.0, 2/speed)
		for button in main_button.get_children():
			if button is Button:
				tween.tween_property(button, "modulate:a", 1.0, 1/speed).from(0.0)
				tween.tween_property(button, "rect_position", (Vector2.UP * (radius + button.rect_size.length())).rotated(deg2rad(angular_seperation * button.get_index() + 1)), 1/speed)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		Input.warp_mouse_position(main_button.rect_global_position + main_button.rect_size/2)
		var tween: SceneTreeTween
		for button in main_button.get_children():
			if button is Button:
				tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
				tween.tween_property(button, "modulate:a", 0.0, 1/speed)
				tween.tween_property(button, "rect_position", Vector2.ZERO, 1/speed)

		tween.set_parallel(false).set_parallel(true).set_trans(Tween.TRANS_BACK)

		tween.tween_property(main_button, "rect_scale", Vector2.ZERO, 2/speed)
		tween.tween_property(main_button, "modulate:a", 0.0, 2/speed)
		tween.tween_property($"%BackLight", "energy", 0.0, 2/speed).set_trans(Tween.TRANS_QUART)
		yield(tween, "finished")
		main_button.hide()
		$"%BackLight".hide()

func button_pressed(index: int):
	get_node(button_container).get_child(index).pressed = false
	yield(get_tree(), "idle_frame")
	get_node(button_container).get_child(index).pressed = true
	print_debug("Switched Tab")

#func is_mouse_in(value: bool) -> void:
#	is_mouse_in = value
#	set_process(value)

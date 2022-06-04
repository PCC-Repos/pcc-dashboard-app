extends Control


export var speed: float = 10
export var radius: float = 100

var is_mouse_in: bool
var pointing_angle: = 0

onready var main_button = $"%MainButton"
onready var angular_seperation: float = 360 / main_button.get_child_count()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_button.hide()
	pass

func _process(_delta: float) -> void:
	pointing_angle = Vector2.ZERO.angle_to_point(get_global_mouse_position())
	main_button.radial_initial_angle = pointing_angle
	if is_mouse_in:
		#	main_button.get_child(0).text = event.as_text()
		if Input.is_action_just_pressed("wheel_button"):
				wheel_buttons_visible()
		elif Input.is_action_just_released("wheel_button"):
				wheel_buttons_visible(false)

func wheel_buttons_visible(value: bool = true):
	if value:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		main_button.show()
		main_button.rect_global_position = get_global_mouse_position() - main_button.rect_size/2
		for button in main_button.get_children():
			if button is Button:
				var tween: SceneTreeTween = button.create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
				tween.tween_property(button, "modulate:a", 1.0, 1/speed).from(0.0)
				tween.tween_property(button, "rect_position", (Vector2.UP * (radius + button.rect_size.length())).rotated(deg2rad(angular_seperation * button.get_index() + 1)), 1/speed)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.warp_mouse_position(main_button.rect_global_position + main_button.rect_size/2)
		var tween: SceneTreeTween
		for button in main_button.get_children():
			if button is Button:
				tween = button.create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
				tween.tween_property(button, "modulate:a", 0.0, 1/speed)
				tween.tween_property(button, "rect_position", Vector2.ZERO, 1/speed)
		yield(tween, "finished")
		main_button.hide()


func is_mouse_in(value: bool) -> void:
	is_mouse_in = value
	set_process(value)

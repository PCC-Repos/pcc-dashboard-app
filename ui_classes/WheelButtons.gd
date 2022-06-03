extends Control


export var key: = KEY_TAB
export var speed: float = 10
export var radius: float = 100

onready var main_button = $"%MainButton"
onready var angular_seperation: float = 360 / main_button.get_child_count()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	main_button.hide()
	pass


func _on_WheelButtons_gui_input(event: InputEvent) -> void:
#	main_button.get_child(0).text = event.as_text()
	if event is InputEventKey:
		if event.scancode == key and event.pressed == true:
			main_button.show()
			main_button.rect_global_position = get_global_mouse_position()
			for button in main_button.get_children():
				var tween: SceneTreeTween = (button as Button).create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
				tween.tween_property(button, "modulate:a", 1.0, 1/speed).from(0.0)
				tween.tween_property(button, "rect_position", (Vector2.UP * radius).rotated(deg2rad(angular_seperation * button.get_index())), 1/speed).from(Vector2.ZERO)
		else:
			main_button.hide()
			var tween: SceneTreeTween
			for button in main_button.get_children():
				tween = (button as Button).create_tween().set_parallel().set_trans(Tween.TRANS_QUART)
				tween.tween_property(button, "modulate:a", 0.0, 1/speed)
				tween.tween_property(button, "rect_position", Vector2.ZERO, 1/speed)
			yield(tween, "finished")
			main_button.hide()

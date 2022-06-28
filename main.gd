extends Control

export(bool) var debug: = true
export(bool) var api_debug: = true
export(float) var tween_duration: = 0.5

onready var logo = $HB/ImageContainer/Logo
onready var tab_container = $HB/MainScreenTabController
onready var image_container = $HB/ImageContainer
onready var hbox = $HB
onready var audio_player = $AudioStreamPlayer

onready var AdminForm = preload("res://forms/AdminForm/AdminForm.tscn")
var admin_scene = null

func _ready():
	if api_debug:
		API.rest._base_url = "https://api.proclubsfederation.com/dev/"
	L.debug("API Base URL", API.rest._base_url)

	var _c
	_c = Store.connect("logged_in", self, "_on_logged_in")
	_c = Store.connect("logged_out", self, "_on_logged_out")
	_c = connect("visibility_changed", self, "_on_visibility_changed")
	_c = tab_container.connect("tab_changed", self, "_on_tab_container_tab_changed")

func ready_tween():
	logo.show()
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_QUART).set_parallel()
	tween.tween_property(tab_container, "rect_position:x", OS.window_size.x / 2 - (OS.window_size.y / 16), tween_duration).from(OS.window_size.x + 10)
	tween.tween_property(logo, "rect_position:x", 50.0, tween_duration).from(-image_container.rect_size.x - 10)

func _on_logged_in():
	hbox.visible = false
	audio_player.stop()
	call_deferred("init_admin")

func _on_logged_out():
	hbox.visible = true
	if admin_scene:
		admin_scene.queue_free()
		admin_scene = null
	#ready_tween()
	audio_player.play()

func init_admin():
	print("initing admin")
	admin_scene = AdminForm.instance()
	hbox.get_parent().add_child(admin_scene)

func _on_visibility_changed() -> void:
	print("Main visibility changed")

func _on_tab_container_tab_changed(_tab: int):
	ready_tween()

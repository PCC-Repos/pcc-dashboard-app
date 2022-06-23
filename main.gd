extends Control

export(bool) var debug: = true
export(bool) var api_debug: = true
export(float) var tween_duration: = 0.5

onready var logo = $HB/ImageContainer/Logo
onready var tab_container = $HB/MainScreenTabController
onready var image_container = $HB/ImageContainer
onready var hbox = $HB
onready var audio_player = $AudioStreamPlayer

func _ready():
	API.rest._base_url = "https://api.proclubsfederation.com/dev/"
	print("API Base: ", API.rest._base_url)

	var _c
	_c = Store.connect("logged_in", self, "_on_logged_in")
	_c = Store.connect("logged_out", self, "_on_logged_out")
	_c = Store.connect("login_failed", self, "_on_login_failed")
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
	ready_tween()
	audio_player.play()

func _on_login_failed():
	$HBoxContainer.show()
	$"%ImageContainer".get_node("CanvasLayer").visible = true
	#ready()

func init_admin():
	print("initing admin")

func _on_visibility_changed() -> void:
	print("Main visibility changed")

func _on_tab_container_tab_changed(_tab: int):
	ready_tween()

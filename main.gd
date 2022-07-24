extends Control

enum ApiEndpoint {
	Public,
	Dev,
	Local
}

export(ApiEndpoint) var api_endpoint = ApiEndpoint.Dev
export(float) var tween_duration: = 0.5

onready var logo = $HB/ImageContainer/Logo
onready var tab_container = $HB/MainScreenTabController
onready var image_container = $HB/ImageContainer
onready var hbox = $HB
onready var audio_player = $AudioStreamPlayer

onready var AdminForm = preload("res://forms/AdminForm/AdminForm.tscn")

var dev_helper = null


func _ready():
	match api_endpoint:
		ApiEndpoint.Public:
			API.rest._base_url = "https://api.proclubsfederation.com/v2"
			Store.ws_url = "wss://gateway.proclubsfederation.com/v1"
		ApiEndpoint.Dev:
			API.rest._base_url = "https://api.proclubsfederation.com/dev"
			Store.ws_url = "wss://gateway.proclubsfederation.com/dev"
		ApiEndpoint.Local:
			API.rest._base_url = "http://localhost:8000"
			Store.ws_url = "ws://localhost:8000/gateway/"
	L.debug("API Base URL", API.rest._base_url)

	var _c
	_c = Store.connect("logged_in", self, "_on_logged_in")
	_c = Store.connect("logged_out", self, "_on_logged_out")
	_c = connect("visibility_changed", self, "_on_visibility_changed")
	_c = tab_container.connect("tab_changed", self, "_on_tab_container_tab_changed")

	Store.try_autologin()

	#TODO: remove this DevHelper once dashboard app is completed
	if not dev_helper:
		dev_helper = DevHelper.new()
		add_child(dev_helper)

	if not OS.is_debug_build():
		audio_player.play()


func ready_tween():
	logo.show()
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_QUART).set_parallel()
	tween.tween_property(tab_container, "rect_position:x", OS.window_size.x / 2 - (OS.window_size.y / 16), tween_duration).from(OS.window_size.x + 10) # warning-ignore:return_value_discarded
	tween.tween_property(logo, "rect_position:x", 50.0, tween_duration).from(-image_container.rect_size.x - 10) # warning-ignore:return_value_discarded


func _on_logged_in():
	hbox.visible = false
	audio_player.stop()
	call_deferred("init_admin")


func _on_logged_out():
	hbox.visible = true
	if Store.admin_scene:
		Store.admin_scene.queue_free()
		Store.admin_scene = null
	ready_tween()


func init_admin():
	Store.admin_scene = AdminForm.instance()
	hbox.get_parent().add_child(Store.admin_scene)


func _on_visibility_changed() -> void:
	# TODO: What is to be done here?
	pass


func _on_tab_container_tab_changed(_tab: int):
	ready_tween()

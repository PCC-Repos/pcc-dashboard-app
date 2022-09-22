extends VBoxContainer

const ItemButton = preload("res://resources/items/item.tscn")

var api_base

onready var item_container = $ScrollContainer/HFlowContainer

func ready():
	pass
#	fetch_items_api()
	connect("visibility_changed", self, "_on_visibility_changed")

func fetch_items_api():
#	clear_children(item_container)
	print("Fetching items")
	var http_req = HTTPRequest.new()
	http_req.connect("request_completed", self, "_fetch_items_api", [http_req])
	add_child(http_req)
	http_req.request(api_base + "marketplace/items/", PoolStringArray(), true, HTTPClient.METHOD_GET)

# warning-ignore:unused_argument
func _fetch_items_api(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http_req):
	http_req.queue_free()
	if response_code != 200:
		print(response_code)
		print(headers)
		print(body.get_string_from_utf8())
		return

	var json = parse_json(body.get_string_from_utf8())
	for item in json:
		_create_item(item)

func _create_item(_item):
	var item = ItemButton.instance()
	item.item_name = _item["name"]
	item.item_text = _item["description"]
	item.item_price = _item["cost"]
	item.connect("mouse_pressed", self, "_show_popup_mouse", [_item["id"]])
	item.connect("long_tap", self, "_show_popup_touch", [_item["id"]])
	item_container.add_child(item)


func refresh():
	fetch_items_api()

func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()

func _option_selected(option_id, item_id):
	match option_id:
		0:
			pass
			# editing, won't be implemented for now
#			emit_signal("show_edit_club_modal", item_id)
		1:
			# deleting
			delete_item_api(item_id)
		# 2 is seperator
		3:
			# copy id
			OS.clipboard = str(item_id)

func delete_item_api(item_id: String):
	print(item_id)


func _show_popup_mouse(button_index, item_id):
	match button_index:
		BUTTON_RIGHT:
			_show_popup(item_id)

func connect_if_disconnected(object: Object, signal_name, to_object, function_name, binds = [], flags = 0):
	if object.is_connected(signal_name, to_object, function_name):
		object.disconnect(signal_name, to_object, function_name)
	return object.connect(signal_name, to_object, function_name, binds, flags)


func _show_popup(item_id):
	$CanvasLayer/ItemsMenu.rect_position = get_global_mouse_position()
	$CanvasLayer/ItemsMenu.popup()
	connect_if_disconnected($CanvasLayer/ItemsMenu, "id_pressed", self, "_option_selected", [item_id])

func _show_popup_touch(_index, _long_tap_time, item_id):
	_show_popup(item_id)


func _on_visibility_changed() -> void:
	if visible: owner.get_recursive_children(self)

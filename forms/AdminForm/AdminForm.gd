extends Control

export var speed: float = 3

onready var account_btn = $Panel/VB/Header/HB/AccountBtn
onready var dialogs = $NextGenDialogs

onready var admin_btn = $Panel/VB/PC/VB/TabButtons/AdminBtn
onready var marketplace_btn = $Panel/VB/PC/VB/TabButtons/MarketplaceBtn


func _ready():
	$AudioStreamRandomPlayer.play()
	match Store.permissions:
		Store.UserPermissionsEnum.USER:
			admin_btn.hide()
			marketplace_btn.hide()
		Store.UserPermissionsEnum.MANAGER:
			admin_btn.hide()
	account_btn.text = "[%s]%s" % [Store.get_user_permission_as_string(), Store.user.name]
	account_btn.get_popup().connect("index_pressed", self, "_on_account_btn_index_pressed")
	NotificationServer.notify_info("Logged in as %s" % Store.user.name)


func _on_account_btn_index_pressed(index: int):
	var item: String = account_btn.get_popup().get_item_text(index)
	match item:
		"Refresh":
			print("refreshing")
		"Settings":
			dialogs.get_node("SettingsDialog").popup()
		"Log Out":
			print("logging out")
			Store.logout()


func get_recursive_children(root: Control):
	if root != null and root.get_child_count() != 0:
		for child in root.get_children():
			if child.get_child_count():
				get_recursive_children(child)

			var tween: = create_tween().set_parallel()
			if child is VSeparator:
				child.rect_pivot_offset.y = child.rect_size.y/2
				tween.tween_property(child, "rect_scale:y", 1.0, 1/speed).from(0.0)
			elif child is HSeparator:
				child.rect_pivot_offset.x = child.rect_size.x/2
				tween.tween_property(child, "rect_scale:x", 1.0, 1/speed).from(0.0)
			elif child is Label:
				tween.tween_property(child, "percent_visible", 1.0, 1/speed).from(0.0)
			else:
				tween.kill()

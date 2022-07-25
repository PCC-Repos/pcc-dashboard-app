extends Control


onready var content_scroll = $ScrollContainer
onready var sc_vb = $ScrollContainer/Transactions

const themed_btn = preload("res://resources/transactions/transaction.tscn")

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")
	
	for child in sc_vb.get_children():
		child.queue_free()
	
	var transactions = yield(API.rest.get_transactions("buyer", Store.user.id), "completed")
	if transactions is HTTPResponse and transactions.is_error():
		NotificationServer.notify_critical(str(transactions))
		return
	for transaction in transactions:
		_create_transaction(transaction)
	transactions = yield(API.rest.get_transactions("seller", Store.user.id), "completed")
	for transaction in transactions:
		_create_transaction(transaction)
	

func _create_transaction(transaction: Transaction):
	var btn = themed_btn.instance()
	btn.name = transaction.id
	btn.buyer = transaction.buyer
	btn.seller = transaction.seller
	btn.item = transaction.item
	btn.price = str(transaction.item.cost)
	sc_vb.add_child(btn)
	

func _on_visibility_changed() -> void:
	if visible:
		var tween: = create_tween()
		rect_pivot_offset = rect_size/2
		tween.tween_property(self, "rect_scale:y", 1.0, 0.3/owner.speed).from(0.0)
		owner.get_recursive_children(self)

tool
extends PanelContainer


export var buyer_name: String setget set_buyer_name
export var seller_name: String setget set_seller_name
export var item_name: String setget set_item_name
export var price: String setget set_price

var buyer setget set_buyer
var seller setget set_seller
var item setget set_item

func _ready():
	set("buyer_name", buyer_name)
	set("seller_name", seller_name)
	set("item_name", item_name)
	set("price", price)


func set_buyer_name(value: String):
	buyer_name = value
	if !is_inside_tree():
		return
	$"%Buyer".text = buyer_name


func set_seller_name(value: String):
	seller_name = value
	if !is_inside_tree():
		return
	$"%Seller".text = seller_name


func set_item_name(value: String):
	item_name = value
	if !is_inside_tree():
		return
	$"%Item".text = item_name


func set_price(value: String):
	price = value
	if !is_inside_tree():
		return
	$"%Price".text = price + " tokens"

func set_buyer(value):
	buyer = value
	self.buyer_name = value["name"]

func set_seller(value):
	seller = value
	self.seller_name = value["name"]

func set_item(value):
	item = value
	self.item_name = value["name"]

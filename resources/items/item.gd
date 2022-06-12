extends MouseButton


export var item_name: String setget set_item_name
export var item_text: String setget set_item_text
export var item_price: int setget set_item_price

onready var item_name_lbl = $"%Name"
onready var item_desc_lbl = $"%Description"
onready var item_price_lbl = $"%Price"

func _ready():
	set("item_name", item_name)
	set("item_text", item_text)
	set("item_price", item_price)

func set_item_name(value: String):
	item_name = value
	if !is_inside_tree():
		return
	item_name_lbl.text = item_name

func set_item_text(value: String):
	item_text = value
	if !is_inside_tree():
		return
	item_desc_lbl.text = item_text

func set_item_price(value: int):
	item_price = value
	if !is_inside_tree():
		return
	item_price_lbl.text = str(item_price) + " tokens"
